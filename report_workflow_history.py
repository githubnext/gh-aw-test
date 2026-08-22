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
from pathlib import Path
from urllib.parse import quote


DEFAULT_REPOSITORY = "githubnext/gh-aw-test"
DEFAULT_WORKFLOW = ".github/workflows/test-copilot-create-issue.lock.yml"
AGENT_STEP_NAMES = ("Execute GitHub Copilot CLI", "Execute Copilot CLI")
SAMPLE_STEP_NAME = "Replay safe-outputs samples (deterministic)"
TIMESTAMP_RE = re.compile(r"(\d{4}-\d\d-\d\dT\d\d:\d\d:\d\d(?:\.\d+)?Z)")
REASONING_PATTERNS = (
    re.compile(r'"event"\s*:\s*"(?:assistant|assistant_message|reasoning|tool_use|tool_call)"', re.I),
    re.compile(r'"(?:role|type)"\s*:\s*"(?:assistant|reasoning)"', re.I),
    re.compile(r'\b(?:assistant|reasoning|thinking)\b.*(?:message|content|delta)', re.I),
    re.compile(r'"method"\s*:\s*"tools/call"', re.I),
)


def parse_time(value: str | None) -> dt.datetime | None:
    if not value:
        return None
    return dt.datetime.fromisoformat(value.replace("Z", "+00:00"))


def seconds(start: str | None, end: str | None) -> float | None:
    start_time, end_time = parse_time(start), parse_time(end)
    return (end_time - start_time).total_seconds() if start_time and end_time else None


def gh_json(repository: str, endpoint: str, paginate: bool = False) -> object:
    command = ["gh", "api"]
    if paginate:
        command.append("--paginate")
    command.extend([f"repos/{repository}/{endpoint}", "--slurp"] if paginate else [f"repos/{repository}/{endpoint}"])
    output = subprocess.run(command, check=True, text=True, capture_output=True).stdout
    return json.loads(output)


def gh_log(repository: str, run_id: int) -> tuple[str | None, bool]:
    result = subprocess.run(
        ["gh", "run", "view", str(run_id), "--repo", repository, "--log"],
        text=True,
        capture_output=True,
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

    for index, (run, jobs, agent, engine_step, sample_step) in enumerate(candidates, 1):
        run_id = run["id"]
        mode = "inference" if engine_step else "samples"
        proxy_step = engine_step or sample_step
        if engine_step:
            log = logs_by_run[run_id]
            reasoning_at, reasoning_marker = first_reasoning_time(log, engine_step["started_at"], engine_step["completed_at"])
        else:
            reasoning_at = sample_step["completed_at"]
            reasoning_marker = "deterministic sample replay completed"
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
            "gh_aw_commit": gh_aw_commit,
            "gh_aw_committed_at": gh_aw_committed_at,
            "time_to_complete_seconds": seconds(run["run_started_at"], run["updated_at"]),
            "agent_job_seconds": seconds(agent["started_at"], agent["completed_at"]),
            "copilot_step_seconds": seconds(engine_step["started_at"], engine_step["completed_at"]) if engine_step else None,
            "detection_job_seconds": seconds(detection["started_at"], detection["completed_at"]) if detection else None,
            "time_to_proxy_step_seconds": seconds(run["run_started_at"], proxy_step["started_at"]),
            "proxy_step_to_first_reasoning_seconds": seconds(proxy_step["started_at"], reasoning_at),
            "time_to_first_reasoning_seconds": seconds(run["run_started_at"], reasoning_at),
            "first_reasoning_at": reasoning_at,
            "first_reasoning_marker": reasoning_marker,
            "major_steps": major_steps,
            "job_steps": job_steps,
        })
        if index % 25 == 0 or index == len(candidates):
            print(f"Processed {index}/{len(candidates)} eligible runs", file=sys.stderr)
    return sorted(records, key=lambda record: (record["gh_aw_committed_at"] or record["date"], record["date"]))


def regressions(records: list[dict[str, object]], metric: str) -> list[dict[str, object]]:
    found = []
    for index, record in enumerate(records):
        value = record[metric]
        prior_mode_records = [item for item in records[:index] if item["mode"] == record["mode"]]
        baseline_values = [item[metric] for item in prior_mode_records[-10:] if item[metric] is not None]
        if value is None or len(baseline_values) < 5:
            continue
        baseline = statistics.median(baseline_values)
        if value >= baseline * 1.5 and value - baseline >= 10:
            found.append({**record, "metric": metric, "baseline_seconds": baseline, "increase_percent": (value / baseline - 1) * 100})
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


def write_svg(path: Path, records: list[dict[str, object]], regression_labels: dict[tuple[int, str], str], regression_legend: list[dict[str, object]]) -> None:
    width, height, margin = 1200, 700, 65
    plot_top, plot_bottom = 65, 455
    metrics = (("time_to_complete_seconds", "Time to complete", "#0969da"), ("time_to_first_reasoning_seconds", "Time to first reasoning proxy", "#cf222e"), ("detection_job_seconds", "Detection job", "#1a7f37"))
    values = [record[key] for record in records for key, _, _ in metrics if record[key] is not None]
    maximum = max(values, default=1) * 1.1
    dated_records = [record for record in records if record["gh_aw_committed_at"]]
    dates = [parse_time(record["gh_aw_committed_at"]).timestamp() for record in dated_records]
    minimum_date, maximum_date = (min(dates), max(dates)) if dates else (0, 1)
    date_span = max(maximum_date - minimum_date, 1)
    lines = [f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}">', '<rect width="100%" height="100%" fill="white"/>', '<style>text{font-family:ui-monospace,monospace;font-size:13px}.axis{stroke:#57606a;stroke-width:1}.grid{stroke:#d8dee4;stroke-width:1}</style>']
    for tick in range(6):
        value = maximum * tick / 5
        y = plot_bottom - (plot_bottom - plot_top) * tick / 5
        lines.extend([f'<line class="grid" x1="{margin}" y1="{y:.1f}" x2="{width-margin}" y2="{y:.1f}"/>', f'<text x="8" y="{y+5:.1f}">{value:.0f}s</text>'])
    for key, label, color in metrics:
        for mode, dash in (("inference", ""), ("samples", ' stroke-dasharray="7 5"')):
            points_text = []
            for record in dated_records:
                value = record[key]
                if value is None or record["mode"] != mode:
                    continue
                stamp = parse_time(record["gh_aw_committed_at"]).timestamp()
                x = margin + (width - 2 * margin) * (stamp - minimum_date) / date_span
                y = plot_bottom - (plot_bottom - plot_top) * value / maximum
                points_text.append(f"{x:.1f},{y:.1f}")
                regression_label = regression_labels.get((record["run_id"], key))
                if regression_label:
                    label_number = int(regression_label[1:])
                    offsets = ((-18, -20), (18, -20), (-18, 20), (18, 20), (0, -28), (0, 28))
                    offset_x, offset_y = offsets[(label_number - 1) % len(offsets)]
                    label_x = min(max(x + offset_x, margin + 11), width - margin - 11)
                    label_y = min(max(y + offset_y, plot_top + 11), plot_bottom - 11)
                    lines.extend([
                        f'<line x1="{x:.1f}" y1="{y:.1f}" x2="{label_x:.1f}" y2="{label_y:.1f}" stroke="{color}" stroke-width="1"/>',
                        f'<circle cx="{label_x:.1f}" cy="{label_y:.1f}" r="11" fill="white" stroke="{color}" stroke-width="2"><title>{regression_label}: {label}, {mode}, {value:.1f}s</title></circle>',
                        f'<text x="{label_x:.1f}" y="{label_y+4:.1f}" fill="{color}" font-size="10" font-weight="bold" text-anchor="middle">{regression_label}</text>',
                    ])
            if points_text:
                lines.append(f'<polyline points="{" ".join(points_text)}" fill="none" stroke="{color}" stroke-width="2"{dash}><title>{label} ({mode})</title></polyline>')
    first_date = parse_time(minimum_date and dt.datetime.fromtimestamp(minimum_date, dt.timezone.utc).isoformat()).date().isoformat() if dated_records else ""
    last_date = parse_time(maximum_date and dt.datetime.fromtimestamp(maximum_date, dt.timezone.utc).isoformat()).date().isoformat() if dated_records else ""
    lines.extend([f'<line class="axis" x1="{margin}" y1="{plot_bottom}" x2="{width-margin}" y2="{plot_bottom}"/>', f'<text x="{margin}" y="{plot_bottom+44}">{first_date}</text>', f'<text x="{width-margin-80}" y="{plot_bottom+44}">{last_date}</text>', '<line x1="650" y1="22" x2="690" y2="22" stroke="#0969da" stroke-width="3"/><text x="700" y="27">Complete</text>', '<line x1="650" y1="44" x2="690" y2="44" stroke="#cf222e" stroke-width="3"/><text x="700" y="49">First proxy</text>', '<line x1="800" y1="22" x2="840" y2="22" stroke="#1a7f37" stroke-width="3"/><text x="850" y="27">Detection</text>', '<line x1="800" y1="44" x2="840" y2="44" stroke="#57606a" stroke-width="3" stroke-dasharray="7 5"/><text x="850" y="49">Samples (dashed)</text>', '<text x="65" y="30" font-size="20">Timing by gh-aw commit date</text>', '<text x="65" y="535" font-size="16" font-weight="bold">Regression episodes</text>'])
    metric_names = {"time_to_complete_seconds": "Complete", "time_to_first_reasoning_seconds": "First proxy", "detection_job_seconds": "Detection"}
    metric_colors = {"time_to_complete_seconds": "#0969da", "time_to_first_reasoning_seconds": "#cf222e", "detection_job_seconds": "#1a7f37"}
    for index, item in enumerate(regression_legend):
        column, row = divmod(index, 6)
        x, y = margin + column * 550, 562 + row * 23
        start, end = item["episode_start"][:10], item["episode_end"][:10]
        episode = start if start == end else f"{start} to {end}"
        label = f"R{index + 1}"
        color = metric_colors[item["metric"]]
        details = f"{episode}  {metric_names[item['metric']]} / {item['mode']}  +{item['increase_percent']:.0f}%"
        lines.extend([f'<text x="{x}" y="{y}" fill="{color}" font-weight="bold">{label}</text>', f'<text x="{x+34}" y="{y}">{details}</text>'])
    lines.append('</svg>')
    path.write_text("\n".join(lines))


def qualifying_job_steps(records: list[dict[str, object]]) -> dict[str, dict[str, list[tuple[dict[str, object], float]]]]:
    occurrences: dict[tuple[str, str], list[tuple[dict[str, object], float]]] = {}
    for record in records:
        for job_name, steps in record["job_steps"].items():
            for step_name, duration in steps.items():
                occurrences.setdefault((job_name, step_name), []).append((record, duration))
    selected: dict[str, dict[str, list[tuple[dict[str, object], float]]]] = {}
    for (job_name, step_name), values in occurrences.items():
        if sum(duration > 10 for _, duration in values) / len(values) > 0.5:
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
    return regression_episodes(points)


def write_step_svg(path: Path, records: list[dict[str, object]], job_name: str, step_series: dict[str, list[tuple[dict[str, object], float]]]) -> None:
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
        f'<text x="{margin}" y="30" font-size="20">Step timing: {html.escape(job_name)} job</text>',
        '<text x="65" y="52">Only steps over 10s in more than 50% of their timed occurrences</text>',
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
        for mode, dash in (("inference", ""), ("samples", ' stroke-dasharray="7 5"')):
            points = []
            markers = []
            for record, duration in values:
                if record["mode"] != mode or not record["gh_aw_committed_at"]:
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
                lines.append(f'<polyline points="{" ".join(points)}" fill="none" stroke="{color}" stroke-width="2"{dash}><title>{escaped_name} ({mode})</title></polyline>')
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
        '<line x1="900" y1="25" x2="940" y2="25" stroke="#57606a" stroke-width="3"/><text x="950" y="30">Inference</text>',
        '<line x1="900" y1="47" x2="940" y2="47" stroke="#57606a" stroke-width="3" stroke-dasharray="7 5"/><text x="950" y="52">Samples</text>',
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


def write_outputs(output_dir: Path, records: list[dict[str, object]]) -> None:
    output_dir.mkdir(parents=True, exist_ok=True)
    regression_points = regressions(records, "time_to_complete_seconds") + regressions(records, "time_to_first_reasoning_seconds") + regressions(records, "detection_job_seconds")
    all_regressions = regression_episodes(regression_points)
    (output_dir / "runs.json").write_text(json.dumps(records, indent=2) + "\n")
    fields = ["run_id", "run_number", "date", "url", "workflow_sha", "mode", "gh_aw_version", "gh_aw_commit", "gh_aw_committed_at", "time_to_complete_seconds", "agent_job_seconds", "copilot_step_seconds", "detection_job_seconds", "time_to_proxy_step_seconds", "proxy_step_to_first_reasoning_seconds", "time_to_first_reasoning_seconds"]
    with (output_dir / "runs.csv").open("w", newline="") as stream:
        writer = csv.DictWriter(stream, fieldnames=fields, extrasaction="ignore", lineterminator="\n")
        writer.writeheader()
        writer.writerows(records)
    regression_labels = {(item["run_id"], item["metric"]): f"R{index}" for index, item in enumerate(all_regressions, 1)}
    write_svg(output_dir / "timing.svg", records, regression_labels, all_regressions)
    selected_job_steps = qualifying_job_steps(records)
    for old_step_graph in output_dir.glob("steps-*.svg"):
        old_step_graph.unlink()
    for job_name, step_series in selected_job_steps.items():
        write_step_svg(output_dir / f"steps-{file_slug(job_name)}.svg", records, job_name, step_series)
    complete = [record["time_to_complete_seconds"] for record in records if record["time_to_complete_seconds"] is not None]
    reasoning = [record["time_to_first_reasoning_seconds"] for record in records if record["time_to_first_reasoning_seconds"] is not None]
    agent_jobs = [record["agent_job_seconds"] for record in records if record["agent_job_seconds"] is not None]
    copilot_steps = [record["copilot_step_seconds"] for record in records if record["copilot_step_seconds"] is not None]
    proxy_start = [record["time_to_proxy_step_seconds"] for record in records if record["time_to_proxy_step_seconds"] is not None]
    proxy_reasoning = [record["proxy_step_to_first_reasoning_seconds"] for record in records if record["proxy_step_to_first_reasoning_seconds"] is not None]
    complete_summary, reasoning_summary = summarize(complete), summarize(reasoning)
    mode_counts = {mode: sum(record["mode"] == mode for record in records) for mode in ("inference", "samples")}
    lines = ["# Copilot create-issue timing", "", f"Analyzed **{len(records)}** successful agent runs: **{mode_counts['inference']} inference** and **{mode_counts['samples']} samples**.", "", "| Metric | Samples | Median | P90 | Min | Max |", "|---|---:|---:|---:|---:|---:|", f"| Time to complete | {complete_summary['count']} | {fmt(complete_summary['median'])} | {fmt(complete_summary['p90'])} | {fmt(complete_summary['min'])} | {fmt(complete_summary['max'])} |", f"| Time to first reasoning/sample proxy | {reasoning_summary['count']} | {fmt(reasoning_summary['median'])} | {fmt(reasoning_summary['p90'])} | {fmt(reasoning_summary['min'])} | {fmt(reasoning_summary['max'])} |", "", "Solid lines are inference runs; dashed lines of the same color are sample runs. The x-axis is the commit time of the resolved gh-aw commit, not the workflow run time.", "", "![Historical timing](timing.svg)", "", "## Candidate regressions", "", f"Found **{len(regression_points)} threshold crossings** grouped into **{len(all_regressions)} episodes**. Baselines are calculated separately for inference and sample runs; each `R#` labels the largest increase in an episode whose crossings are no more than three gh-aw commit-days apart.", "", "| Label | Episode | Mode | Metric | Peak | Prior median | Increase | Run | gh-aw version / commit |", "|---|---|---|---|---:|---:|---:|---|---|"]
    for index, item in enumerate(all_regressions, 1):
        gh_aw_commit = item["gh_aw_commit"][:12] if item["gh_aw_commit"] else "unresolved"
        episode_start = item["episode_start"][:10]
        episode_end = item["episode_end"][:10]
        episode = episode_start if episode_start == episode_end else f"{episode_start} to {episode_end}"
        lines.append(f"| R{index} | {episode} ({item['episode_points']} point{'s' if item['episode_points'] != 1 else ''}) | {item['mode']} | {item['metric']} | {fmt(item[item['metric']])} | {fmt(item['baseline_seconds'])} | {item['increase_percent']:.0f}% | [#{item['run_number']}]({item['url']}) | `{item['gh_aw_version']}` / `{gh_aw_commit}` |")
    step_values: dict[str, list[float]] = {}
    for record in records:
        for name, duration in record["major_steps"].items():
            step_values.setdefault(name, []).append(duration)
    lines.extend(["", "## Job and major steps", "", "| Job or step | Samples | Median | P90 |", "|---|---:|---:|---:|"])
    detection_jobs = [record["detection_job_seconds"] for record in records if record["detection_job_seconds"] is not None]
    for name, values in [("Workflow start to proxy step", proxy_start), ("Proxy step to reasoning/sample proxy", proxy_reasoning), ("Agent job", agent_jobs), ("Execute GitHub Copilot CLI", copilot_steps), ("Detection job", detection_jobs)]:
        summary = summarize(values)
        lines.append(f"| {name} | {summary['count']} | {fmt(summary['median'])} | {fmt(summary['p90'])} |")
    for name, values in sorted(step_values.items(), key=lambda item: statistics.median(item[1]), reverse=True):
        if name in AGENT_STEP_NAMES:
            continue
        summary = summarize(values)
        lines.append(f"| {name} | {summary['count']} | {fmt(summary['median'])} | {fmt(summary['p90'])} |")
    lines.extend(["", "## Step timing by job", "", "A step is included when its duration is over 10 seconds in more than 50% of its timed occurrences. Exact job and step names define each series, so renamed steps begin or end naturally."])
    for job_name, step_series in sorted(selected_job_steps.items()):
        lines.extend(["", f"### {job_name}", "", f"![{job_name} step timing](steps-{file_slug(job_name)}.svg)", "", "| Step | Timed occurrences | Over 10s | Median | P90 |", "|---|---:|---:|---:|---:|"])
        for step_name, values in sorted(step_series.items()):
            durations = [duration for _, duration in values]
            summary = summarize(durations)
            over_ten = sum(duration > 10 for duration in durations)
            lines.append(f"| {step_name} | {len(durations)} | {over_ten / len(durations):.0%} | {fmt(summary['median'])} | {fmt(summary['p90'])} |")
    lines.extend(["", "## Method", "", "Only overall-successful `workflow_dispatch` runs with a successful `agent` job are included. Inference runs require a successful `Execute GitHub Copilot CLI` step; sample runs require a successful deterministic replay step. Time to complete is `run.updated_at - run.run_started_at`. The first-proxy metric is end to end from `run.run_started_at`. For inference, its endpoint is the first timestamped assistant/reasoning event or agent-originated `tools/call`; for samples, it is deterministic replay completion. Detection is the standalone `detection` job duration and is present only for non-sample runs. Step durations come directly from the GitHub Actions jobs API (`completed_at - started_at`) for successful steps in successful jobs. Runs without resolvable gh-aw commit dates remain in CSV/JSON but are omitted from the time-axis graphs.", ""])
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