# AGENTS.md

Guidance for AI coding agents (Copilot, Claude, Codex, etc.) working in this
repository. Humans should read `README.md` first; this file documents the
conventions and operational details that an agent needs in order to make safe,
useful changes without breaking the end-to-end test harness or the live
GitHub repository it talks to.

## 1. What this repository is

`gh-aw-test` is the **live integration test bed** for
[`github/gh-aw`](https://github.com/github/gh-aw) — the GitHub CLI extension
that compiles natural-language "agentic workflows" (`.md` files with YAML
frontmatter) into real GitHub Actions workflows (`.lock.yml`).

This repo is **not** a library and produces no artifacts. Its only purpose is
to exercise gh-aw against a real GitHub repository, with real AI engines
(Copilot, Claude, Codex), real issues, real pull requests, real discussions,
real branches, and real code scanning alerts. Test runs mutate the live
`githubnext/gh-aw-test` repository on GitHub.

Treat every change as if it will ship to production tonight: the nightly
matrix in `.github/workflows/e2e.yml` will exercise it against three different
gh-aw refs (main, latest pre-release, latest stable) at 03:00 UTC.

## 2. Top-level layout

```
e2e.sh                          # The test runner. ~3.6k lines of bash.
clean.sh                        # Closes/deletes stray issues/PRs/branches.
README.md                       # Human-facing usage + coverage matrix.
AGENTS.md                       # This file.
fails.txt                       # Persistent list of currently-failing tests.
.github/workflows/
  e2e.yml                       # Nightly matrix runner (CI mode).
  cleaner.yml                   # Periodic cleanup of stray resources.
  permissions.yml               # Permissions audit workflow.
  copilot-setup-steps.yml       # Bootstraps the Copilot engine in CI.
  agentics-maintenance.yml      # gh-aw self-maintenance workflow.
  mcp-lockdown-mode-proof.yml   # MCP lockdown demonstration.
  test-<engine>-<feature>.md    # 88 agentic workflow source files.
  test-<engine>-<feature>.lock.yml  # Generated lockfiles — DO NOT hand-edit.
  shared/mcp/                   # Reusable MCP server definitions.
trials/                         # Scratch space, ignored by tests.
e2e-test-*.log                  # Per-run logs (gitignored).
*.md status files               # CONSOLIDATION_COMPLETE.md, etc. — historical
                                # design notes, safe to ignore unless asked.
```

## 3. The test naming convention is load-bearing

`e2e.sh` discovers tests by globbing `.github/workflows/test-*.md` and parses
the filename to decide engine, variant, and expected behaviour. The schema is:

```
test-<engine>[-<variant>]-<feature>.md
```

- `<engine>` is one of `claude`, `codex`, `copilot`. This is parsed by
  `extract_ai_type` in `e2e.sh` and drives which labels, title prefix, and
  expected outputs the harness asserts.
- `<variant>` is optional and is one of `nosandbox`, `siderepo`. These
  variants run the same feature under different sandboxing/network
  configurations.
- `<feature>` matches a gh-aw safe-output name (`create-issue`,
  `add-comment`, `push-to-pull-request-branch`, ...) or a higher-level
  capability (`mcp`, `gh-steps`, `command`, `custom-safe-outputs`).

If you add a workflow that does not match this pattern, **the runner will
silently skip it**. If you rename an engine substring, you will break the
label-matching and pass/fail detection.

## 4. Workflow source vs. lockfile

Every test has two files:

- `test-foo.md` — the gh-aw source. Edit this.
- `test-foo.lock.yml` — the compiled Actions workflow. **Generated.**

To regenerate after editing a `.md`:

```bash
gh aw compile .github/workflows/test-foo.md
```

To recompile the entire suite (the standard pre-PR step):

```bash
gh aw compile .github/workflows/
```

Never hand-edit a `.lock.yml`. The nightly matrix recompiles them against
multiple gh-aw refs and will overwrite any local edits. If a lockfile looks
wrong, the bug is either in the `.md` source or in gh-aw itself.

## 5. `samples:` blocks make tests deterministic

Most workflows declare a `samples:` block under `safe-outputs:` (see
`test-copilot-create-issue.md` for a canonical example). When `e2e.sh` is run
with `--use-samples`, gh-aw uses the declared sample instead of calling the
AI engine, which is faster, free, and reproducible.

Inventory of which workflows do/do not have samples:

```bash
ls .github/workflows/test-*.md | wc -l               # total
grep -l "samples:" .github/workflows/test-*.md | wc -l   # with samples
for f in .github/workflows/test-*.md; do
  grep -q "samples:" "$f" || basename "$f"
done                                                  # without samples
```

The only workflows intentionally without `samples:` are
`test-copilot-custom-safe-outputs`, `test-copilot-dispatch-workflow`, and
`test-copilot-apm-skill-discovery`, because their purpose is to exercise the
live engine path.

## 6. Running tests locally

Prerequisites: `gh` CLI authenticated, push access to `githubnext/gh-aw-test`,
and a local clone of `github/gh-aw` if you plan to use `--gh-aw-ref`.

```bash
./e2e.sh                              # Everything.
./e2e.sh --dry-run                    # See what would run.
./e2e.sh --workflow-dispatch-only     # Skip issue/PR/command-triggered tests.
./e2e.sh --use-samples                # Deterministic; no engine calls.
./e2e.sh --batch-size 5               # Default is 10 parallel.
./e2e.sh --no-parallel                # Serial; easier to read logs.
./e2e.sh test-copilot-create-issue    # Single test.
./e2e.sh 'test-copilot-*'             # Glob patterns.
./e2e.sh rerun                        # Re-run everything in fails.txt.
./e2e.sh report                       # File GitHub issues for fails.txt.
./e2e.sh --gh-aw-ref main             # Build ../gh-aw at <ref> and use it.
```

The runner writes a timestamped `e2e-test-YYYYMMDD-HHMMSS.log` and updates
`fails.txt` in place. The logs are gitignored (`*.log`); `fails.txt` is
**tracked** and committed (it is the persisted failure list, see §7).

## 7. `fails.txt` is the source of truth for failures

`fails.txt` is a plain-text list of currently-failing test names, one per
line, optionally followed by space-separated GitHub Actions run IDs. The
runner mutates it as it goes:

- `record_test_pass` removes a test from `fails.txt`.
- `record_test_fail` appends the test name and the failing run ID.

When you fix a test, do not edit `fails.txt` by hand — run the test, let the
runner remove it. When triaging, use `./e2e.sh rerun` to re-run only what is
in `fails.txt`, and `./e2e.sh report` to open issues for each entry.

## 8. CI mode and the nightly matrix

`.github/workflows/e2e.yml` runs `./e2e.sh --gh-aw-ref <ref>
--workflow-dispatch-only` for `main`, the latest pre-release, and the latest
stable release of gh-aw, every night at 03:00 UTC. The matrix is **serial**
(`max-parallel: 1`); each entry recompiles its workflows, **pushes them to
`main`**, and dispatches every test from `main`. Running from `main` exercises
the common case users hit and keeps create-pull-request's `fetch-depth: 1`
merge-base against `origin/main` trivially resolvable. Because GitHub Actions
exports `CI=true`, the runner enters **CI mode**:

- It **does** commit/push recompiled lockfiles to `main` (serial entries
  cannot clobber each other).
- It does **not** mutate the repository's `TEMP_USER_PAT` secret.
- It does **not** run issue/comment/PR-triggered tests (only `workflow_dispatch`).

The practical effect: the nightly matrix validates that `gh aw compile`
succeeds against every `.md` for every gh-aw ref, and that the dispatch
tests currently on `main` still pass. Cross-trigger behaviour is only
exercised locally or via manual `workflow_dispatch` of `e2e.yml`.

If you change `e2e.sh`, sanity-check the CI-mode branches by running
`CI=true ./e2e.sh --dry-run` before pushing.

## 9. Parallelism, locks, and shared state

The runner uses bash arrays plus disk locks for parallel execution:

- `BATCH_SIZE=10` controls fan-out; tune with `--batch-size N`.
- `RESULTS_LOCK=/tmp/e2e-results-$$.lock` serialises updates to
  `PASSED_TESTS` / `FAILED_TESTS`.
- `GLOBAL_WORKFLOWS_LOCK=/tmp/e2e-workflows-$$.lock` serialises the
  enable/disable list used by the exit trap.
- `RESULTS_FILE=/tmp/e2e-results-$$.txt` aggregates child-process results.

The exit trap in `cleanup_on_exit` disables every workflow recorded in
`GLOBAL_WORKFLOWS_TO_DISABLE`, even on Ctrl-C. If you add a new code path
that enables a workflow, also push its name into that array, or it will be
left enabled and consume scheduled runs.

See `PARALLEL_FIXES_IMPLEMENTED.md` and `PARALLEL_TEST_CONFLICT_ASSESSMENT.md`
for the prior incidents this design avoids — read them before increasing
`BATCH_SIZE` past 10 or removing locks.

## 10. Shell style for `e2e.sh`

- `set -uo pipefail` is intentional. **Do not add `-e`**: individual test
  failures must not abort the suite.
- Every user-visible message goes through `log` / `info` / `success` /
  `warning` / `error` / `progress`. They tee to both stdout and `LOG_FILE`.
- Wrap commands that may fail (network, `gh` API) in `safe_run`.
- Functions live in `e2e.sh`; do not split into sourced files without
  updating the trap and lock paths.
- `bash -n e2e.sh` must pass before any commit that touches it.
- Quote every variable (`"$var"`), prefer `[[ ]]` over `[ ]`, prefer `$(...)`
  over backticks.

## 11. `clean.sh` and the live repository

`clean.sh` closes open issues, closes open PRs, closes discussions, and
deletes test branches. It supports `--dry-run`. Run it any time the live
repo accumulates noise, and **always** run `./clean.sh --dry-run` first if
you have changed it — a bug here can mass-close real work.

Cleanup is best-effort. If the GraphQL discussions API rejects a node ID,
the script logs and continues; it does not fail the run.

## 12. Secrets and tokens

- `GH_AW_TEST_PAT` — repository secret; PAT used by CI for all operations
  except Copilot-engine requests.
- `TEMP_USER_PAT` — set/unset by `e2e.sh` during local runs only, never in
  CI (guarded by `CI=true`). Used to exercise cross-repo flows
  (`siderepo` variants).
- Engine credentials (Copilot, Claude, Codex) are configured at the GitHub
  app / repository level; agents should never write engine keys to disk.

Do not echo tokens. Do not add `set -x` to `e2e.sh` without first scrubbing
secret-handling sections.

## 13. Adding a new test

1. Pick a name: `test-<engine>-<feature>.md`. Match an existing pattern.
2. Copy the closest existing `.md` (e.g. `test-copilot-create-issue.md`)
   and edit the frontmatter and prompt.
3. Add a `samples:` block so the test can run deterministically with
   `--use-samples`.
4. Run `gh aw compile .github/workflows/test-<engine>-<feature>.md` to
   produce the lockfile. Commit both.
5. Run `./e2e.sh test-<engine>-<feature>` locally and confirm pass.
6. Update the coverage matrix in `README.md` (the `[ ]` / `[x]` checklist).
7. Do **not** edit `fails.txt`. If the test fails the first time, leave it
   for the runner to record.

## 14. Things not to do

- Do not commit `e2e-test-*.log` (gitignored via `*.log`). `fails.txt.bak`
  is **not** gitignored — do not commit stray copies of it either.
- Do not delete `e2e.sh.backup` or `e2e.sh.before-full-consolidation`
  without confirming with the maintainer — they document the consolidation
  documented in `CONSOLIDATION_COMPLETE.md`.
- Do not change `REPO_OWNER` / `REPO_NAME` in `e2e.sh`. They are hard-coded
  to `githubnext/gh-aw-test` on purpose.
- Do not enable a workflow without queueing its name for disable in the
  exit trap.
- Do not bypass the lock files; bash array writes from parallel children
  will corrupt results otherwise.
- Do not generate URLs in code or docs that you have not verified. Live
  GitHub run IDs in `fails.txt` are written by the runner from real
  `gh run` output.

## 15. Where to look for prior context

The following files are historical design notes left in the repo root.
They are **not** consumed by any tool — feel free to skim, but do not
treat them as current spec:

- `CONSOLIDATION_COMPLETE.md` — the `e2e.sh` consolidation that produced
  the current single-file runner.
- `PARALLEL_FIXES_IMPLEMENTED.md` — what changed when parallel batching
  landed.
- `PARALLEL_TEST_CONFLICT_ASSESSMENT.md` — assessment that justifies the
  current locking scheme.
- `WORKFLOW_STATE_MANAGEMENT.md` — design of enable/disable + trap.
- `ERROR_HANDLING_ASSESSMENT.md` — why `set -e` is deliberately absent.

When these notes contradict the code, the code wins.

## 16. Quick smoke test before committing

```bash
bash -n e2e.sh                                # syntax
bash -n clean.sh
./e2e.sh --dry-run                            # exercises discovery + parsing
gh aw compile .github/workflows/              # all sources compile
git diff --stat .github/workflows/*.lock.yml  # confirm only intended lockfile changes
```

If any step fails, fix it before pushing. The nightly matrix is the
last line of defence, not the first.
