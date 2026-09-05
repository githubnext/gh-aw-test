#!/usr/bin/env python3
"""Report historical timing for successful agentic workflow runs."""

from __future__ import annotations

import argparse
import base64
import concurrent.futures
import csv
import datetime as dt
import html
import json
import math
import re
import statistics
import subprocess
import sys
import time
from pathlib import Path
from urllib.parse import quote


DEFAULT_REPOSITORY = "githubnext/gh-aw-test"
DEFAULT_WORKFLOW = ".github/workflows/test-copilot-create-issue.lock.yml"
AGENT_STEP_NAMES = ("Execute GitHub Copilot CLI", "Execute Copilot CLI")
SAMPLE_STEP_NAME = "Replay safe-outputs samples (deterministic)"
TIMESTAMP_RE = re.compile(r"(\d{4}-\d\d-\d\dT\d\d:\d\d:\d\d(?:\.\d+)?Z)")
COPILOT_PHASE_LABELS = {
    "awf_startup_seconds": "Copilot phase — AWF startup",
    "harness_startup_seconds": "Copilot phase — harness startup",
    "copilot_process_seconds": "Copilot phase — Copilot process",
}
AWF_ENTRYPOINT_RE = re.compile(r"\[entrypoint\].*Agentic Workflow Firewall - Agent Container", re.I)
COPILOT_PROCESS_STARTED_RE = re.compile(r"\[copilot-harness\].*attempt \d+: process started\b", re.I)
COPILOT_PROCESS_CLOSED_RE = re.compile(r"\[copilot-harness\].*attempt \d+: process closed\b", re.I)
RELEASE_VERSION_RE = re.compile(r"^v\d+\.\d+\.\d+$")
REASONING_PATTERNS = (
    re.compile(r'"event"\s*:\s*"(?:assistant|assistant_message|reasoning|tool_use|tool_call)"', re.I),
    re.compile(r'"(?:role|type)"\s*:\s*"(?:assistant|reasoning)"', re.I),
    re.compile(r'\b(?:assistant|reasoning|thinking)\b.*(?:message|content|delta)', re.I),
    re.compile(r'"method"\s*:\s*"tools/call"', re.I),
)
MAIN_METRICS = (
    ("time_to_complete_seconds", "Complete", "#0969da"),
    ("time_to_first_reasoning_seconds", "First proxy", "#cf222e"),
    ("job:pre-activation", "Pre-activation", "#8250df"),
    ("job:activation", "Activation", "#bf8700"),
    ("job:agent", "Agent", "#0550ae"),
    ("job:detection", "Detection", "#1a7f37"),
    ("job:safe_outputs", "Safe Outputs", "#953800"),
    ("job:conclusion", "Conclusion", "#57606a"),
)
REPORT_JOBS = ("activation", "agent", "detection", "safe_outputs", "conclusion")
REGRESSION_WINDOW = dt.timedelta(weeks=6)


def parse_time(value: str | None) -> dt.datetime | None:
    if not value:
        return None
    return dt.datetime.fromisoformat(value.replace("Z", "+00:00"))


def seconds(start: str | None, end: str | None) -> float | None:
    start_time, end_time = parse_time(start), parse_time(end)
    return (end_time - start_time).total_seconds() if start_time and end_time else None


def rate_limit_delay(error: str, attempt: int) -> float:
    if "rate limit exceeded" not in error.lower():
        return 2 ** (attempt - 1)
    result = subprocess.run(
        ["gh", "api", "rate_limit", "--jq", ".resources.core.reset"],
        text=True,
        capture_output=True,
    )
    if result.returncode == 0:
        try:
            return max(1, int(result.stdout.strip()) - int(time.time()) + 5)
        except ValueError:
            pass
    return 60


def run_gh(command: list[str], attempts: int = 4) -> subprocess.CompletedProcess[str]:
    for attempt in range(1, attempts + 1):
        result = subprocess.run(command, text=True, capture_output=True)
        if result.returncode == 0:
            return result
        error = result.stderr.strip() or result.stdout.strip() or f"exit status {result.returncode}"
        print(f"GitHub API request failed ({attempt}/{attempts}): {error}", file=sys.stderr)
        if attempt < attempts:
            delay = rate_limit_delay(error, attempt)
            print(f"Retrying in {delay:.0f}s", file=sys.stderr)
            time.sleep(delay)
    return result


def gh_json(repository: str, endpoint: str, paginate: bool = False, attempts: int = 4) -> object:
    command = ["gh", "api"]
    if paginate:
        command.append("--paginate")
    command.extend([f"repos/{repository}/{endpoint}", "--slurp"] if paginate else [f"repos/{repository}/{endpoint}"])
    result = run_gh(command, attempts)
    if result.returncode == 0:
        return json.loads(result.stdout)
    raise subprocess.CalledProcessError(result.returncode, command, output=result.stdout, stderr=result.stderr)


def gh_log(repository: str, run_id: int) -> tuple[str | None, bool]:
    result = run_gh(
        ["gh", "run", "view", str(run_id), "--repo", repository, "--log"],
    )
    return (result.stdout, False) if result.returncode == 0 else (None, "HTTP 410" in result.stderr)


def first_reasoning_time(log: str | None, step_start: str, step_end: str) -> tuple[str | None, str | None]:
    if not log:
        return None, "log unavailable"
    start, end = parse_time(step_start), parse_time(step_end)
    for line in log.splitlines():
        if not any(pattern.search(line) for pattern in REASONING_PATTERNS):
            continue
        timestamps = [(value, parse_time(value)) for value in TIMESTAMP_RE.findall(line)]
        in_step = [(value, timestamp) for value, timestamp in timestamps if start and end and start <= timestamp <= end]
        if in_step:
            value, _ = min(in_step, key=lambda item: item[1])
            return value, line[-240:]
    return None, "no observable reasoning marker"


def copilot_phase_timings(log: str | None, step_start: str, step_end: str) -> dict[str, float | None]:
    """Split the engine step around AWF entry and Copilot process lifecycle markers."""
    result = {key: None for key in COPILOT_PHASE_LABELS}
    if not log:
        return result
    start, end = parse_time(step_start), parse_time(step_end)
    if not start or not end:
        return result

    markers: dict[str, list[dt.datetime]] = {"entrypoint": [], "process_started": [], "process_closed": []}
    patterns = {
        "entrypoint": AWF_ENTRYPOINT_RE,
        "process_started": COPILOT_PROCESS_STARTED_RE,
        "process_closed": COPILOT_PROCESS_CLOSED_RE,
    }
    for line in log.splitlines():
        marker = next((name for name, pattern in patterns.items() if pattern.search(line)), None)
        if not marker:
            continue
        timestamps = [parse_time(value) for value in TIMESTAMP_RE.findall(line)]
        markers[marker].extend(timestamp for timestamp in timestamps if start <= timestamp <= end)

    entrypoint = min(markers["entrypoint"], default=None)
    process_started = min(markers["process_started"], default=None)
    process_closed = max(markers["process_closed"], default=None)
    if entrypoint:
        result["awf_startup_seconds"] = (entrypoint - start).total_seconds()
    if entrypoint and process_started and process_started >= entrypoint:
        result["harness_startup_seconds"] = (process_started - entrypoint).total_seconds()
    if process_started and process_closed and process_closed >= process_started:
        result["copilot_process_seconds"] = (process_closed - process_started).total_seconds()
    return result


def percentile(values: list[float], fraction: float) -> float | None:
    if not values:
        return None
    ordered = sorted(values)
    index = (len(ordered) - 1) * fraction
    lower, upper = math.floor(index), math.ceil(index)
    return ordered[lower] if lower == upper else ordered[lower] + (ordered[upper] - ordered[lower]) * (index - lower)


def summarize(values: list[float]) -> dict[str, float | int | None]:
    return {
        "count": len(values),
        "median": statistics.median(values) if values else None,
        "p90": percentile(values, 0.90),
        "mean": statistics.mean(values) if values else None,
        "min": min(values) if values else None,
        "max": max(values) if values else None,
    }


def fmt(value: float | None) -> str:
    return "n/a" if value is None else f"{value:.1f}s"


def normalized_name(value: str) -> str:
    return re.sub(r"[-_\s]+", "", value).lower()


def metric_value(record: dict[str, object], metric: str) -> float | None:
    if not metric.startswith("job:"):
        return record.get(metric)
    target = normalized_name(metric.removeprefix("job:"))
    for job_name, duration in record["job_durations"].items():
        if normalized_name(job_name) == target:
            return duration
    return None


def load_jobs(repository: str, cache_dir: Path, run_id: int) -> dict[str, object]:
    jobs_path = cache_dir / f"{run_id}-jobs.json"
    if jobs_path.exists():
        return json.loads(jobs_path.read_text())
    jobs = gh_json(repository, f"actions/runs/{run_id}/jobs?per_page=100")
    jobs_path.write_text(json.dumps(jobs))
    return jobs


def load_compiler_version(repository: str, workflow: str, cache_dir: Path, workflow_sha: str) -> str | None:
    metadata_path = cache_dir / f"{workflow_sha}-metadata.json"
    if metadata_path.exists():
        return json.loads(metadata_path.read_text()).get("compiler_version")
    response = gh_json(repository, f"contents/{quote(workflow, safe='/')}?ref={workflow_sha}")
    first_line = base64.b64decode(response["content"]).decode(errors="replace").splitlines()[0]
    prefix = "# gh-aw-metadata: "
    metadata = json.loads(first_line.removeprefix(prefix)) if first_line.startswith(prefix) else {}
    metadata_path.write_text(json.dumps(metadata))
    return metadata.get("compiler_version")


def load_log(repository: str, cache_dir: Path, run_id: int) -> str | None:
    log_path = cache_dir / f"{run_id}.log"
    unavailable_path = cache_dir / f"{run_id}.log.unavailable"
    if log_path.exists():
        return log_path.read_text(errors="replace")
    if unavailable_path.exists():
        return None
    log, permanently_unavailable = gh_log(repository, run_id)
    if log is not None:
        log_path.write_text(log)
    elif permanently_unavailable:
        unavailable_path.touch()
    return log


def resolve_gh_aw_commit(version: str) -> dict[str, str | None]:
    described_commit = re.search(r"-g([0-9a-f]{7,40})(?:-dirty)?$", version)
    ref = described_commit.group(1) if described_commit else version
    try:
        response = gh_json("github/gh-aw", f"commits/{quote(ref, safe='')}")
        commit = response["sha"]
        committed_at = response["commit"]["committer"]["date"]
    except subprocess.CalledProcessError:
        commit, committed_at = None, None
    return {"sha": commit, "committed_at": committed_at}


def load_release_kinds() -> dict[str, str]:
    pages = gh_json("github/gh-aw", "releases?per_page=100", paginate=True)
    return {
        release["tag_name"]: "pre-release" if release["prerelease"] else "release"
        for page in pages
        for release in page
        if not release["draft"]
    }


def classify_gh_aw_ref(version: str | None, release_kinds: dict[str, str]) -> str:
    if not version:
        return "unknown"
    if version in release_kinds:
        return "released"
    return "released" if RELEASE_VERSION_RE.fullmatch(version) else "main"


def collect(repository: str, workflow: str, cache_dir: Path, limit: int | None, workers: int) -> list[dict[str, object]]:
    workflow_id = quote(workflow, safe="")
    pages = gh_json(
        repository,
        f"actions/workflows/{workflow_id}/runs?event=workflow_dispatch&status=success&per_page=100",
        paginate=True,
    )
    runs = [run for page in pages for run in page["workflow_runs"]]
    if limit:
        runs = runs[:limit]
    cache_dir.mkdir(parents=True, exist_ok=True)
    records: list[dict[str, object]] = []
    with concurrent.futures.ThreadPoolExecutor(max_workers=workers) as executor:
        jobs_by_run = dict(zip(
            (run["id"] for run in runs),
            executor.map(lambda run: load_jobs(repository, cache_dir, run["id"]), runs),
        ))
    candidates = []
    for run in runs:
        jobs = jobs_by_run[run["id"]]
        agent = next((job for job in jobs["jobs"] if job["name"] == "agent" and job["conclusion"] == "success"), None)
        if not agent:
            continue
        engine_step = next((step for step in agent["steps"] if step["name"] in AGENT_STEP_NAMES and step["conclusion"] == "success"), None)
        sample_step = next((step for step in agent["steps"] if step["name"] == SAMPLE_STEP_NAME and step["conclusion"] == "success"), None)
        if engine_step or sample_step:
            candidates.append((run, jobs, agent, engine_step, sample_step))

    workflow_shas = sorted({run["head_sha"] for run, _, _, _, _ in candidates})
    with concurrent.futures.ThreadPoolExecutor(max_workers=workers) as executor:
        versions_by_sha = dict(zip(
            workflow_shas,
            executor.map(lambda sha: load_compiler_version(repository, workflow, cache_dir, sha), workflow_shas),
        ))

    inference_ids = [run["id"] for run, _, _, engine_step, _ in candidates if engine_step]
    with concurrent.futures.ThreadPoolExecutor(max_workers=workers) as executor:
        logs_by_run = dict(zip(
            inference_ids,
            executor.map(lambda run_id: load_log(repository, cache_dir, run_id), inference_ids),
        ))

    revisions_path = cache_dir / "gh-aw-revisions.json"
    revisions = json.loads(revisions_path.read_text()) if revisions_path.exists() else {}
    compiler_versions = sorted({version for version in versions_by_sha.values() if version})
    unresolved_versions = [version for version in compiler_versions if not isinstance(revisions.get(version), dict)]
    with concurrent.futures.ThreadPoolExecutor(max_workers=workers) as executor:
        revisions.update(zip(unresolved_versions, executor.map(resolve_gh_aw_commit, unresolved_versions)))
    revisions_path.write_text(json.dumps(revisions, indent=2) + "\n")
    release_kinds = load_release_kinds()

    for index, (run, jobs, agent, engine_step, sample_step) in enumerate(candidates, 1):
        run_id = run["id"]
        mode = "inference" if engine_step else "samples"
        proxy_step = engine_step or sample_step
        if engine_step:
            log = logs_by_run[run_id]
            reasoning_at, reasoning_marker = first_reasoning_time(log, engine_step["started_at"], engine_step["completed_at"])
            copilot_phases = copilot_phase_timings(log, engine_step["started_at"], engine_step["completed_at"])
        else:
            reasoning_at = sample_step["completed_at"]
            reasoning_marker = "deterministic sample replay completed"
            copilot_phases = {key: None for key in COPILOT_PHASE_LABELS}
        detection = next((job for job in jobs["jobs"] if job["name"] == "detection" and job["conclusion"] == "success"), None)
        major_steps = {
            step["name"]: seconds(step["started_at"], step["completed_at"])
            for step in agent["steps"]
            if step["conclusion"] == "success" and seconds(step["started_at"], step["completed_at"]) >= 2
        }
        job_steps = {
            job["name"]: {
                step["name"]: seconds(step["started_at"], step["completed_at"])
                for step in job.get("steps", [])
                if step["conclusion"] == "success" and seconds(step["started_at"], step["completed_at"]) is not None
            }
            for job in jobs["jobs"]
            if job["conclusion"] == "success"
        }
        for key, label in COPILOT_PHASE_LABELS.items():
            if copilot_phases[key] is not None:
                job_steps.setdefault("agent", {})[label] = copilot_phases[key]
        job_durations = {
            job["name"]: duration
            for job in jobs["jobs"]
            if job["conclusion"] == "success"
            if (duration := seconds(job["started_at"], job["completed_at"])) is not None and duration >= 0
        }
        compiler_version = versions_by_sha[run["head_sha"]]
        revision = revisions.get(compiler_version, {})
        gh_aw_commit = revision.get("sha") if isinstance(revision, dict) else None
        gh_aw_committed_at = revision.get("committed_at") if isinstance(revision, dict) else None
        records.append({
            "run_id": run_id,
            "run_number": run["run_number"],
            "date": run["run_started_at"],
            "url": run["html_url"],
            "workflow_sha": run["head_sha"],
            "mode": mode,
            "gh_aw_version": compiler_version,
            "gh_aw_ref_kind": classify_gh_aw_ref(compiler_version, release_kinds),
            "gh_aw_commit": gh_aw_commit,
            "gh_aw_committed_at": gh_aw_committed_at,
            "time_to_complete_seconds": seconds(run["run_started_at"], run["updated_at"]),
            "agent_job_seconds": seconds(agent["started_at"], agent["completed_at"]),
            "copilot_step_seconds": seconds(engine_step["started_at"], engine_step["completed_at"]) if engine_step else None,
            **copilot_phases,
            "detection_job_seconds": seconds(detection["started_at"], detection["completed_at"]) if detection else None,
            "time_to_proxy_step_seconds": seconds(run["run_started_at"], proxy_step["started_at"]),
            "proxy_step_to_first_reasoning_seconds": seconds(proxy_step["started_at"], reasoning_at),
            "time_to_first_reasoning_seconds": seconds(run["run_started_at"], reasoning_at),
            "first_reasoning_at": reasoning_at,
            "first_reasoning_marker": reasoning_marker,
            "major_steps": major_steps,
            "job_steps": job_steps,
            "job_durations": job_durations,
        })
        if index % 25 == 0 or index == len(candidates):
            print(f"Processed {index}/{len(candidates)} eligible runs", file=sys.stderr)
    return sorted(records, key=lambda record: (record["gh_aw_committed_at"] or record["date"], record["date"]))


def regressions(records: list[dict[str, object]], metric: str) -> list[dict[str, object]]:
    found = []
    for index, record in enumerate(records):
        value = metric_value(record, metric)
        prior_mode_records = [item for item in records[:index] if item["mode"] == record["mode"]]
        baseline_values = [metric_value(item, metric) for item in prior_mode_records[-10:]]
        baseline_values = [item for item in baseline_values if item is not None]
        if value is None or len(baseline_values) < 5:
            continue
        baseline = statistics.median(baseline_values)
        if value >= baseline * 1.5 and value - baseline >= 10:
            found.append({**record, "metric": metric, "value_seconds": value, "baseline_seconds": baseline, "increase_percent": (value / baseline - 1) * 100})
    return found


def regression_episodes(regression_points: list[dict[str, object]], gap_days: int = 3) -> list[dict[str, object]]:
    episodes = []
    keys = sorted({(item["metric"], item["mode"]) for item in regression_points})
    for metric, mode in keys:
        points = sorted(
            (item for item in regression_points if item["metric"] == metric and item["mode"] == mode and item["gh_aw_committed_at"]),
            key=lambda item: item["gh_aw_committed_at"],
        )
        current = []
        for point in points:
            if current:
                gap = parse_time(point["gh_aw_committed_at"]) - parse_time(current[-1]["gh_aw_committed_at"])
                if gap > dt.timedelta(days=gap_days):
                    peak = max(current, key=lambda item: item["increase_percent"])
                    episodes.append({**peak, "episode_start": current[0]["gh_aw_committed_at"], "episode_end": current[-1]["gh_aw_committed_at"], "episode_points": len(current)})
                    current = []
            current.append(point)
        if current:
            peak = max(current, key=lambda item: item["increase_percent"])
            episodes.append({**peak, "episode_start": current[0]["gh_aw_committed_at"], "episode_end": current[-1]["gh_aw_committed_at"], "episode_points": len(current)})
    return sorted(episodes, key=lambda item: (item["episode_start"], item["metric"], item["mode"]))


def recent_regression_episodes(
    regression_points: list[dict[str, object]],
    now: dt.datetime | None = None,
) -> list[dict[str, object]]:
    cutoff = (now or dt.datetime.now(dt.timezone.utc)) - REGRESSION_WINDOW
    return [
        episode
        for episode in regression_episodes(regression_points)
        if parse_time(episode["episode_end"]) >= cutoff
    ]


def write_svg(
    path: Path,
    records: list[dict[str, object]],
    ref_kind: str,
    mode: str,
    regression_legend: list[dict[str, object]],
) -> None:
    width, margin = 1200, 65
    plot_top, plot_bottom = 115, 505
    mode_records = [record for record in records if record["mode"] == mode]
    metrics = [item for item in MAIN_METRICS if any(metric_value(record, item[0]) is not None for record in mode_records)]
    values = [metric_value(record, key) for record in mode_records for key, _, _ in metrics]
    maximum = max((value for value in values if value is not None), default=1) * 1.1
    dated_records = [record for record in mode_records if record["gh_aw_committed_at"]]
    dates = [parse_time(record["gh_aw_committed_at"]).timestamp() for record in dated_records]
    minimum_date, maximum_date = (min(dates), max(dates)) if dates else (0, 1)
    date_span = max(maximum_date - minimum_date, 1)
    regression_labels = {(item["run_id"], item["metric"]): f"R{index}" for index, item in enumerate(regression_legend, 1)}
    regression_top = 570
    height = max(620, regression_top + 35 + len(regression_legend) * 22)
    lines = [
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}">',
        '<rect width="100%" height="100%" fill="white"/>',
        '<style>text{font-family:ui-monospace,monospace;font-size:13px}.axis{stroke:#57606a;stroke-width:1}.grid{stroke:#d8dee4;stroke-width:1}</style>',
        f'<text x="{margin}" y="30" font-size="20">Run and job timing: {ref_kind}, using {mode}</text>',
        '<text x="65" y="52">First proxy is measured from workflow start to first reasoning or sample completion</text>',
    ]
    for tick in range(6):
        value = maximum * tick / 5
        y = plot_bottom - (plot_bottom - plot_top) * tick / 5
        lines.extend([f'<line class="grid" x1="{margin}" y1="{y:.1f}" x2="{width-margin}" y2="{y:.1f}"/>', f'<text x="8" y="{y+5:.1f}">{value:.0f}s</text>'])
    if dated_records:
        for tick in range(9):
            x = margin + (width - 2 * margin) * tick / 8
            lines.append(f'<line class="grid" x1="{x:.1f}" y1="{plot_top}" x2="{x:.1f}" y2="{plot_bottom}"/>')
    for key, label, color in metrics:
        points = []
        markers = []
        for record in dated_records:
            value = metric_value(record, key)
            if value is None:
                continue
            stamp = parse_time(record["gh_aw_committed_at"]).timestamp()
            x = margin + (width - 2 * margin) * (stamp - minimum_date) / date_span
            y = plot_bottom - (plot_bottom - plot_top) * value / maximum
            points.append(f"{x:.1f},{y:.1f}")
            regression_label = regression_labels.get((record["run_id"], key))
            if regression_label:
                label_number = int(regression_label[1:])
                offsets = ((-18, -20), (18, -20), (-18, 20), (18, 20), (0, -28), (0, 28))
                offset_x, offset_y = offsets[(label_number - 1) % len(offsets)]
                label_x = min(max(x + offset_x, margin + 11), width - margin - 11)
                label_y = min(max(y + offset_y, plot_top + 11), plot_bottom - 11)
                markers.extend([f'<line x1="{x:.1f}" y1="{y:.1f}" x2="{label_x:.1f}" y2="{label_y:.1f}" stroke="{color}" stroke-width="1"/>', f'<circle cx="{label_x:.1f}" cy="{label_y:.1f}" r="11" fill="white" stroke="{color}" stroke-width="2"><title>{regression_label}: {label}, {value:.1f}s</title></circle>', f'<text x="{label_x:.1f}" y="{label_y+4:.1f}" fill="{color}" font-size="10" font-weight="bold" text-anchor="middle">{regression_label}</text>'])
        if points:
            lines.append(f'<polyline points="{" ".join(points)}" fill="none" stroke="{color}" stroke-width="2"><title>{label}</title></polyline>')
            lines.extend(markers)
    if dated_records:
        for tick in range(9):
            stamp = minimum_date + date_span * tick / 8
            x = margin + (width - 2 * margin) * tick / 8
            anchor = "start" if tick == 0 else "end" if tick == 8 else "middle"
            date_label = dt.datetime.fromtimestamp(stamp, dt.timezone.utc).date().isoformat()
            lines.append(f'<text x="{x:.1f}" y="{plot_bottom+25}" text-anchor="{anchor}">{date_label}</text>')
    lines.append(f'<line class="axis" x1="{margin}" y1="{plot_bottom}" x2="{width-margin}" y2="{plot_bottom}"/>')
    for index, (_, label, color) in enumerate(metrics):
        column, row = divmod(index, 2)
        x, y = 560 + column * 155, 28 + row * 23
        lines.extend([f'<line x1="{x}" y1="{y-5}" x2="{x+30}" y2="{y-5}" stroke="{color}" stroke-width="3"/>', f'<text x="{x+38}" y="{y}">{label}</text>'])
    metric_names = {key: label for key, label, _ in metrics}
    metric_colors = {key: color for key, _, color in metrics}
    if regression_legend:
        lines.append(f'<text x="{margin}" y="{regression_top}" font-size="16" font-weight="bold">Regression episodes</text>')
    for index, item in enumerate(regression_legend):
        x, y = margin, regression_top + 28 + index * 22
        start, end = item["episode_start"][:10], item["episode_end"][:10]
        episode = start if start == end else f"{start} to {end}"
        label = f"R{index + 1}"
        color = metric_colors[item["metric"]]
        details = f"{episode}  {metric_names[item['metric']]}  +{item['increase_percent']:.0f}%"
        lines.extend([f'<text x="{x}" y="{y}" fill="{color}" font-weight="bold">{label}</text>', f'<text x="{x+34}" y="{y}">{details}</text>'])
    lines.append('</svg>')
    path.write_text("\n".join(lines))


def step_selection_reasons(values: list[float]) -> list[str]:
    reasons = []
    if statistics.median(values) > 10:
        reasons.append("overall median >10s")
    if len(values) >= 3 and statistics.median(values[-5:]) > 10:
        reasons.append("recent median >10s")
    for index in range(max(0, len(values) - 5), len(values)):
        prior_values = values[max(0, index - 10):index]
        if len(prior_values) < 5:
            continue
        baseline = statistics.median(prior_values)
        if values[index] >= baseline * 1.5 and values[index] - baseline >= 10:
            reasons.append("recent regression")
            break
    return reasons


def qualifying_job_steps(records: list[dict[str, object]]) -> dict[str, dict[str, list[tuple[dict[str, object], float]]]]:
    occurrences: dict[tuple[str, str], list[tuple[dict[str, object], float]]] = {}
    for record in records:
        for job_name, steps in record["job_steps"].items():
            for step_name, duration in steps.items():
                occurrences.setdefault((job_name, step_name), []).append((record, duration))
    selected: dict[str, dict[str, list[tuple[dict[str, object], float]]]] = {}
    for (job_name, step_name), values in occurrences.items():
        if step_selection_reasons([duration for _, duration in values]):
            selected.setdefault(job_name, {})[step_name] = values
    return selected


def file_slug(value: str) -> str:
    return re.sub(r"[^a-z0-9]+", "-", value.lower()).strip("-") or "job"


def step_regression_episodes(step_series: dict[str, list[tuple[dict[str, object], float]]]) -> list[dict[str, object]]:
    points = []
    for step_name, values in step_series.items():
        for index, (record, duration) in enumerate(values):
            prior_values = [value for prior_record, value in values[:index] if prior_record["mode"] == record["mode"]][-10:]
            if len(prior_values) < 5:
                continue
            baseline = statistics.median(prior_values)
            if duration >= baseline * 1.5 and duration - baseline >= 10:
                points.append({
                    **record,
                    "metric": step_name,
                    "duration_seconds": duration,
                    "baseline_seconds": baseline,
                    "increase_percent": (duration / baseline - 1) * 100,
                })
    return recent_regression_episodes(points)


def write_step_svg(
    path: Path,
    records: list[dict[str, object]],
    ref_kind: str,
    mode: str,
    job_name: str,
    step_series: dict[str, list[tuple[dict[str, object], float]]],
) -> None:
    width, margin = 1200, 65
    plot_top, plot_bottom = 75, 465
    colors = ("#0969da", "#cf222e", "#1a7f37", "#8250df", "#bf8700", "#0550ae", "#9a6700", "#116329")
    series_colors = {step_name: colors[index % len(colors)] for index, step_name in enumerate(sorted(step_series))}
    regression_legend = step_regression_episodes(step_series)
    regression_labels = {(item["run_id"], item["metric"]): f"R{index}" for index, item in enumerate(regression_legend, 1)}
    series_legend_top = 525
    regression_legend_top = series_legend_top + len(step_series) * 22 + 18
    height = max(575, regression_legend_top + 32 + len(regression_legend) * 22)
    dated_records = [record for record in records if record["gh_aw_committed_at"]]
    dates = [parse_time(record["gh_aw_committed_at"]).timestamp() for record in dated_records]
    minimum_date, maximum_date = (min(dates), max(dates)) if dates else (0, 1)
    date_span = max(maximum_date - minimum_date, 1)
    durations = [duration for values in step_series.values() for record, duration in values if record["gh_aw_committed_at"]]
    maximum = max(durations, default=1) * 1.1
    lines = [
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}">',
        '<rect width="100%" height="100%" fill="white"/>',
        '<style>text{font-family:ui-monospace,monospace;font-size:13px}.axis{stroke:#57606a;stroke-width:1}.grid{stroke:#d8dee4;stroke-width:1}</style>',
        f'<text x="{margin}" y="30" font-size="20">Major step timing: {html.escape(job_name)} job ({ref_kind}, using {mode})</text>',
        '<text x="65" y="52">Steps with a sustained cost, recent slowdown, or recent regression</text>',
    ]
    for tick in range(6):
        value = maximum * tick / 5
        y = plot_bottom - (plot_bottom - plot_top) * tick / 5
        lines.extend([f'<line class="grid" x1="{margin}" y1="{y:.1f}" x2="{width-margin}" y2="{y:.1f}"/>', f'<text x="8" y="{y+5:.1f}">{value:.0f}s</text>'])
    if dated_records:
        for tick in range(9):
            x = margin + (width - 2 * margin) * tick / 8
            lines.append(f'<line class="grid" x1="{x:.1f}" y1="{plot_top}" x2="{x:.1f}" y2="{plot_bottom}"/>')
    for series_index, (step_name, values) in enumerate(sorted(step_series.items())):
        color = series_colors[step_name]
        points = []
        markers = []
        for record, duration in values:
            if not record["gh_aw_committed_at"]:
                continue
            stamp = parse_time(record["gh_aw_committed_at"]).timestamp()
            x = margin + (width - 2 * margin) * (stamp - minimum_date) / date_span
            y = plot_bottom - (plot_bottom - plot_top) * duration / maximum
            points.append(f"{x:.1f},{y:.1f}")
            regression_label = regression_labels.get((record["run_id"], step_name))
            if regression_label:
                label_number = int(regression_label[1:])
                offsets = ((-18, -22), (18, -22), (-18, 22), (18, 22), (0, -30), (0, 30))
                offset_x, offset_y = offsets[(label_number - 1) % len(offsets)]
                label_x = min(max(x + offset_x, margin + 11), width - margin - 11)
                label_y = min(max(y + offset_y, plot_top + 11), plot_bottom - 11)
                markers.extend([
                    f'<line x1="{x:.1f}" y1="{y:.1f}" x2="{label_x:.1f}" y2="{label_y:.1f}" stroke="{color}" stroke-width="1"/>',
                    f'<circle cx="{label_x:.1f}" cy="{label_y:.1f}" r="11" fill="white" stroke="{color}" stroke-width="2"><title>{regression_label}: {html.escape(step_name)}, {mode}, {duration:.1f}s</title></circle>',
                    f'<text x="{label_x:.1f}" y="{label_y+4:.1f}" fill="{color}" font-size="10" font-weight="bold" text-anchor="middle">{regression_label}</text>',
                ])
        if points:
            escaped_name = html.escape(step_name)
            lines.append(f'<polyline points="{" ".join(points)}" fill="none" stroke="{color}" stroke-width="2"><title>{escaped_name}</title></polyline>')
            lines.extend(markers)
        legend_y = series_legend_top + series_index * 22
        lines.extend([f'<line x1="{margin}" y1="{legend_y-4}" x2="{margin+35}" y2="{legend_y-4}" stroke="{color}" stroke-width="3"/>', f'<text x="{margin+45}" y="{legend_y}">{html.escape(step_name)}</text>'])
    if dated_records:
        for tick in range(9):
            stamp = minimum_date + date_span * tick / 8
            x = margin + (width - 2 * margin) * tick / 8
            date_label = dt.datetime.fromtimestamp(stamp, dt.timezone.utc).date().isoformat()
            anchor = "start" if tick == 0 else "end" if tick == 8 else "middle"
            lines.append(f'<text x="{x:.1f}" y="{plot_bottom+25}" text-anchor="{anchor}">{date_label}</text>')
    lines.extend([
        f'<line class="axis" x1="{margin}" y1="{plot_bottom}" x2="{width-margin}" y2="{plot_bottom}"/>',
    ])
    if regression_legend:
        lines.append(f'<text x="{margin}" y="{regression_legend_top}" font-size="16" font-weight="bold">Regression episodes</text>')
        for index, item in enumerate(regression_legend, 1):
            y = regression_legend_top + 28 + (index - 1) * 22
            start, end = item["episode_start"][:10], item["episode_end"][:10]
            episode = start if start == end else f"{start} to {end}"
            color = series_colors[item["metric"]]
            details = f"{episode}  {item['metric']} / {item['mode']}  +{item['increase_percent']:.0f}%"
            lines.extend([f'<text x="{margin}" y="{y}" fill="{color}" font-weight="bold">R{index}</text>', f'<text x="{margin+34}" y="{y}">{html.escape(details)}</text>'])
    lines.append('</svg>')
    path.write_text("\n".join(lines))


def job_step_series(
    records: list[dict[str, object]],
    job_name: str,
) -> dict[str, list[tuple[dict[str, object], float]]]:
    selected = qualifying_job_steps(records).get(job_name, {})
    if job_name == "agent":
        all_series = all_job_step_series(records, job_name)
        for label in COPILOT_PHASE_LABELS.values():
            if label in all_series:
                selected[label] = all_series[label]
    return selected


def all_job_step_series(
    records: list[dict[str, object]],
    job_name: str,
) -> dict[str, list[tuple[dict[str, object], float]]]:
    series: dict[str, list[tuple[dict[str, object], float]]] = {}
    for record in records:
        for step_name, duration in record["job_steps"].get(job_name, {}).items():
            series.setdefault(step_name, []).append((record, duration))
    return series


def append_summary_table(lines: list[str], records: list[dict[str, object]]) -> None:
    metrics = [
        ("Workflow complete", [record["time_to_complete_seconds"] for record in records]),
        ("Workflow start to proxy step", [record["time_to_proxy_step_seconds"] for record in records]),
        ("Proxy step to first reasoning/sample", [record["proxy_step_to_first_reasoning_seconds"] for record in records]),
    ]
    for key, label in COPILOT_PHASE_LABELS.items():
        values = [record.get(key) for record in records]
        if any(value is not None for value in values):
            metrics.append((label, values))
    for job_name in REPORT_JOBS:
        metrics.append((f"Job `{job_name}`", [metric_value(record, f"job:{job_name}") for record in records]))
    major_steps: dict[str, list[float]] = {}
    for record in records:
        for step_name, duration in record["major_steps"].items():
            major_steps.setdefault(step_name, []).append(duration)
    for step_name, values in sorted(major_steps.items(), key=lambda item: statistics.median(item[1]), reverse=True):
        metrics.append((f"Major step `{step_name}`", values))
    lines.extend(["", "| Run or job | Samples | Median | P90 |", "|---|---:|---:|---:|"])
    for label, values in metrics:
        summary = summarize([value for value in values if value is not None])
        lines.append(f"| {label} | {summary['count']} | {fmt(summary['median'])} | {fmt(summary['p90'])} |")


def append_job_regressions(
    lines: list[str],
    step_series: dict[str, list[tuple[dict[str, object], float]]],
) -> None:
    episodes = step_regression_episodes(step_series)
    lines.extend(["", "#### Candidate regressions (last six weeks)"])
    if not episodes:
        lines.extend(["", "No candidate regressions in the last six weeks."])
        return
    lines.extend([
        "",
        "| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |",
        "|---|---|---|---:|---:|---:|---|---|",
    ])
    for index, item in enumerate(episodes, 1):
        commit = item["gh_aw_commit"][:12] if item["gh_aw_commit"] else "unresolved"
        start, end = item["episode_start"][:10], item["episode_end"][:10]
        episode = start if start == end else f"{start} to {end}"
        lines.append(
            f"| R{index} | {episode} | {item['metric']} | {fmt(item['duration_seconds'])} | "
            f"{fmt(item['baseline_seconds'])} | {item['increase_percent']:.0f}% | "
            f"[#{item['run_number']}]({item['url']}) | `{item['gh_aw_version']}` / `{commit}` |"
        )


def append_report_cell(
    lines: list[str],
    output_dir: Path,
    records: list[dict[str, object]],
    ref_kind: str,
    mode: str,
) -> None:
    cell_records = [
        record
        for record in records
        if record.get("gh_aw_ref_kind") == ref_kind and record["mode"] == mode
    ]
    slug = f"{ref_kind}-{mode}"
    run_points = [point for metric, _, _ in MAIN_METRICS for point in regressions(cell_records, metric)]
    write_svg(
        output_dir / f"timing-{slug}.svg",
        cell_records,
        ref_kind,
        mode,
        recent_regression_episodes(run_points),
    )
    lines.extend([
        "",
        f"## Run, job & step times (`{ref_kind}`, using {mode})",
        "",
        f"**{len(cell_records)} successful runs.** Regressions shown below are limited to the last six weeks.",
        "",
        f"![Run and job times for {ref_kind}, using {mode}](timing-{slug}.svg)",
    ])
    append_summary_table(lines, cell_records)
    for job_name in REPORT_JOBS:
        graph_series = job_step_series(cell_records, job_name)
        write_step_svg(
            output_dir / f"steps-{file_slug(job_name)}-{slug}.svg",
            cell_records,
            ref_kind,
            mode,
            job_name,
            graph_series,
        )
        lines.extend([
            "",
            f"### Major step times for job `{job_name}` (`{ref_kind}`, using {mode})",
            "",
            f"![Major step times for {job_name}, {ref_kind}, using {mode}](steps-{file_slug(job_name)}-{slug}.svg)",
        ])
        append_job_regressions(lines, all_job_step_series(cell_records, job_name))


def write_outputs(output_dir: Path, records: list[dict[str, object]]) -> None:
    output_dir.mkdir(parents=True, exist_ok=True)
    (output_dir / "runs.json").write_text(json.dumps(records, indent=2) + "\n")
    fields = ["run_id", "run_number", "date", "url", "workflow_sha", "mode", "gh_aw_version", "gh_aw_ref_kind", "gh_aw_commit", "gh_aw_committed_at", "time_to_complete_seconds", "agent_job_seconds", "copilot_step_seconds", *COPILOT_PHASE_LABELS, "detection_job_seconds", "time_to_proxy_step_seconds", "proxy_step_to_first_reasoning_seconds", "time_to_first_reasoning_seconds"]
    with (output_dir / "runs.csv").open("w", newline="") as stream:
        writer = csv.DictWriter(stream, fieldnames=fields, extrasaction="ignore", lineterminator="\n")
        writer.writeheader()
        writer.writerows(records)
    for old_graph in output_dir.glob("*.svg"):
        old_graph.unlink()
    lines = ["# Performance history for `copilot-create-issue.md`"]
    for ref_kind, mode in (
        ("main", "inference"),
        ("released", "inference"),
        ("main", "samples"),
        ("released", "samples"),
    ):
        append_report_cell(lines, output_dir, records, ref_kind, mode)
    lines.extend(["", "## Method", "", "Each section fixes both independent dimensions: gh-aw source (`main` or combined stable/pre-release `released`) and execution mode (`inference` or `samples`). Only overall-successful `workflow_dispatch` runs with a successful `agent` job are included. Candidate regression baselines use up to ten preceding observations from the same section and step; displayed regression episodes are limited to the six weeks before report generation. A step is graphed when it has a sustained cost, recent slowdown, or recent regression. Runs with missing compiler metadata remain in CSV/JSON but are excluded from graphs.", "", "For inference runs, `Execute GitHub Copilot CLI` is additionally split using timestamped runtime markers: **AWF startup** is step start to the AWF agent-container entrypoint, **harness startup** is that entrypoint to the first Copilot process start, and **Copilot process** is the first process start through the final process close (including retries and retry delays). Cleanup after process close remains visible only in the full step duration, while unavailable markers produce no phase value.", ""])
    (output_dir / "report.md").write_text("\n".join(lines))


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repository", default=DEFAULT_REPOSITORY)
    parser.add_argument("--workflow", default=DEFAULT_WORKFLOW)
    parser.add_argument("--output", type=Path, default=Path("workflow-history-report"))
    parser.add_argument("--limit", type=int, help="Analyze only the newest N successful runs")
    parser.add_argument("--workers", type=int, default=8, help="Maximum concurrent GitHub requests (default: 8)")
    args = parser.parse_args()
    if args.workers < 1:
        parser.error("--workers must be at least 1")
    records = collect(args.repository, args.workflow, args.output / "cache", args.limit, args.workers)
    write_outputs(args.output, records)
    print(f"Wrote {args.output / 'report.md'} ({len(records)} eligible runs)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())