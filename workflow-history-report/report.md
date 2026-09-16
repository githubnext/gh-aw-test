# Performance history for `copilot-create-issue.md`

## Run, job & step times (`main`, using inference)

**67 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for main, using inference](timing-main-inference.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 67 | 333.0s | 441.8s |
| Workflow start to proxy step | 67 | 108.0s | 145.4s |
| Proxy step to first reasoning/sample | 65 | 21.0s | 27.4s |
| Copilot phase — AWF startup | 65 | 13.4s | 17.3s |
| Copilot phase — harness startup | 65 | 2.5s | 4.9s |
| Copilot phase — Copilot process | 65 | 8.4s | 10.9s |
| Job `activation` | 67 | 47.0s | 74.4s |
| Job `agent` | 67 | 89.0s | 172.4s |
| Job `detection` | 67 | 70.0s | 92.4s |
| Job `safe_outputs` | 67 | 38.0s | 62.8s |
| Job `conclusion` | 67 | 41.0s | 58.8s |
| Major step `Execute GitHub Copilot CLI` | 67 | 29.0s | 114.0s |
| Major step `Set up job` | 67 | 17.0s | 21.4s |
| Major step `Install ripgrep` | 6 | 14.0s | 19.0s |
| Major step `Download container images` | 67 | 11.0s | 18.4s |
| Major step `Start MCP Gateway` | 67 | 6.0s | 11.0s |
| Major step `Install GitHub Copilot CLI` | 67 | 4.0s | 8.4s |
| Major step `Setup Scripts` | 66 | 3.0s | 5.0s |
| Major step `Download activation artifact` | 36 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 25 | 2.0s | 2.0s |
| Major step `Checkout repository` | 14 | 2.0s | 2.0s |
| Major step `Install AWF binary` | 4 | 2.0s | 2.0s |
| Major step `Stop MCP Gateway` | 9 | 2.0s | 2.0s |
| Major step `Print firewall logs` | 1 | 2.0s | 2.0s |
| Major step `Audit pre-agent workspace` | 1 | 2.0s | 2.0s |

### Major step times for job `activation` (`main`, using inference)

![Major step times for activation, main, using inference](steps-activation-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-08 | Set up job | 63.0s | 34.5s | 83% | [#341](https://github.com/githubnext/gh-aw-test/actions/runs/32552452139) | `v0.86.1-57-gba0a9f9589` / `ba0a9f958976` |
| R2 | 2026-08-08 | Setup Scripts | 18.0s | 3.0s | 500% | [#341](https://github.com/githubnext/gh-aw-test/actions/runs/32552452139) | `v0.86.1-57-gba0a9f9589` / `ba0a9f958976` |
| R3 | 2026-08-17 | Set up job | 48.0s | 31.5s | 52% | [#352](https://github.com/githubnext/gh-aw-test/actions/runs/32558234273) | `v0.87.0-133-g2b2cf3fb01` / `2b2cf3fb01ee` |

### Major step times for job `agent` (`main`, using inference)

![Major step times for agent, main, using inference](steps-agent-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-07 | Download container images | 24.0s | 11.0s | 118% | [#340](https://github.com/githubnext/gh-aw-test/actions/runs/32552050221) | `v0.86.1-3-ge1e298d64b` / `e1e298d64bfa` |
| R2 | 2026-08-07 | Execute GitHub Copilot CLI | 38.0s | 22.5s | 69% | [#340](https://github.com/githubnext/gh-aw-test/actions/runs/32552050221) | `v0.86.1-3-ge1e298d64b` / `e1e298d64bfa` |
| R3 | 2026-08-14 | Copilot phase — AWF startup | 23.2s | 12.9s | 80% | [#349](https://github.com/githubnext/gh-aw-test/actions/runs/32556073604) | `v0.86.2-73-gc35faf436c` / `c35faf436c79` |
| R4 | 2026-08-14 | Execute GitHub Copilot CLI | 38.0s | 23.0s | 65% | [#349](https://github.com/githubnext/gh-aw-test/actions/runs/32556073604) | `v0.86.2-73-gc35faf436c` / `c35faf436c79` |

### Major step times for job `detection` (`main`, using inference)

![Major step times for detection, main, using inference](steps-detection-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-18 | Execute GitHub Copilot CLI | 50.0s | 31.5s | 59% | [#353](https://github.com/githubnext/gh-aw-test/actions/runs/32558698273) | `v0.87.1-4-g4845f00caf` / `4845f00caf46` |

### Major step times for job `safe_outputs` (`main`, using inference)

![Major step times for safe_outputs, main, using inference](steps-safe-outputs-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-14 to 2026-08-16 | Set up job | 69.0s | 29.0s | 138% | [#349](https://github.com/githubnext/gh-aw-test/actions/runs/32556073604) | `v0.86.2-73-gc35faf436c` / `c35faf436c79` |

### Major step times for job `conclusion` (`main`, using inference)

![Major step times for conclusion, main, using inference](steps-conclusion-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-17 | Upload usage artifact | 11.0s | 1.0s | 1000% | [#352](https://github.com/githubnext/gh-aw-test/actions/runs/32558234273) | `v0.87.0-133-g2b2cf3fb01` / `2b2cf3fb01ee` |
| R2 | 2026-08-19 | Set up job | 48.0s | 28.0s | 71% | [#354](https://github.com/githubnext/gh-aw-test/actions/runs/32559121042) | `v0.87.1-44-g5d5e0af5c4` / `5d5e0af5c46c` |

## Run, job & step times (`released`, using inference)

**32 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for released, using inference](timing-released-inference.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 32 | 206.5s | 317.1s |
| Workflow start to proxy step | 32 | 59.0s | 89.9s |
| Proxy step to first reasoning/sample | 26 | 20.7s | 26.7s |
| Copilot phase — AWF startup | 26 | 12.8s | 17.2s |
| Copilot phase — harness startup | 26 | 1.5s | 4.1s |
| Copilot phase — Copilot process | 26 | 8.0s | 8.8s |
| Job `activation` | 32 | 16.5s | 47.2s |
| Job `agent` | 32 | 72.0s | 157.0s |
| Job `detection` | 32 | 51.5s | 72.0s |
| Job `safe_outputs` | 32 | 11.0s | 14.0s |
| Job `conclusion` | 32 | 13.0s | 19.9s |
| Major step `Execute GitHub Copilot CLI` | 32 | 30.0s | 115.9s |
| Major step `Download container images` | 32 | 12.0s | 17.0s |
| Major step `Start MCP Gateway` | 32 | 6.0s | 7.0s |
| Major step `Install GitHub Copilot CLI` | 32 | 4.0s | 5.0s |
| Major step `Set up job` | 30 | 3.0s | 4.0s |
| Major step `Setup Scripts` | 27 | 3.0s | 4.0s |
| Major step `Stop MCP Gateway` | 5 | 2.0s | 2.0s |
| Major step `Install AWF binary` | 3 | 2.0s | 2.0s |
| Major step `Download activation artifact` | 9 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 6 | 2.0s | 2.0s |
| Major step `Checkout repository` | 8 | 2.0s | 2.0s |

### Major step times for job `activation` (`released`, using inference)

![Major step times for activation, released, using inference](steps-activation-released-inference.svg)

#### Candidate regressions (last six weeks)

No candidate regressions in the last six weeks.

### Major step times for job `agent` (`released`, using inference)

![Major step times for agent, released, using inference](steps-agent-released-inference.svg)

#### Candidate regressions (last six weeks)

No candidate regressions in the last six weeks.

### Major step times for job `detection` (`released`, using inference)

![Major step times for detection, released, using inference](steps-detection-released-inference.svg)

#### Candidate regressions (last six weeks)

No candidate regressions in the last six weeks.

### Major step times for job `safe_outputs` (`released`, using inference)

![Major step times for safe_outputs, released, using inference](steps-safe-outputs-released-inference.svg)

#### Candidate regressions (last six weeks)

No candidate regressions in the last six weeks.

### Major step times for job `conclusion` (`released`, using inference)

![Major step times for conclusion, released, using inference](steps-conclusion-released-inference.svg)

#### Candidate regressions (last six weeks)

No candidate regressions in the last six weeks.

## Run, job & step times (`main`, using samples)

**74 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for main, using samples](timing-main-samples.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 74 | 190.0s | 243.5s |
| Workflow start to proxy step | 74 | 98.0s | 121.0s |
| Proxy step to first reasoning/sample | 74 | 0.0s | 1.0s |
| Job `activation` | 74 | 44.0s | 64.0s |
| Job `agent` | 74 | 44.5s | 55.7s |
| Job `detection` | 0 | n/a | n/a |
| Job `safe_outputs` | 74 | 31.0s | 42.0s |
| Job `conclusion` | 74 | 33.0s | 52.7s |
| Major step `Download container images` | 74 | 9.0s | 12.7s |
| Major step `Set up job` | 74 | 7.0s | 11.7s |
| Major step `Start MCP Gateway` | 74 | 7.0s | 12.0s |
| Major step `Install GitHub Copilot CLI` | 74 | 4.0s | 5.0s |
| Major step `Setup Scripts` | 73 | 2.0s | 4.0s |
| Major step `Checkout repository` | 12 | 2.0s | 2.0s |
| Major step `Install AWF binary` | 5 | 2.0s | 2.0s |
| Major step `Download activation artifact` | 22 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 13 | 2.0s | 2.0s |
| Major step `Stop MCP Gateway` | 6 | 2.0s | 2.0s |

### Major step times for job `activation` (`main`, using samples)

![Major step times for activation, main, using samples](steps-activation-main-samples.svg)

#### Candidate regressions (last six weeks)

No candidate regressions in the last six weeks.

### Major step times for job `agent` (`main`, using samples)

![Major step times for agent, main, using samples](steps-agent-main-samples.svg)

#### Candidate regressions (last six weeks)

No candidate regressions in the last six weeks.

### Major step times for job `detection` (`main`, using samples)

![Major step times for detection, main, using samples](steps-detection-main-samples.svg)

#### Candidate regressions (last six weeks)

No candidate regressions in the last six weeks.

### Major step times for job `safe_outputs` (`main`, using samples)

![Major step times for safe_outputs, main, using samples](steps-safe-outputs-main-samples.svg)

#### Candidate regressions (last six weeks)

No candidate regressions in the last six weeks.

### Major step times for job `conclusion` (`main`, using samples)

![Major step times for conclusion, main, using samples](steps-conclusion-main-samples.svg)

#### Candidate regressions (last six weeks)

No candidate regressions in the last six weeks.

## Run, job & step times (`released`, using samples)

**105 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for released, using samples](timing-released-samples.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 105 | 114.0s | 160.6s |
| Workflow start to proxy step | 105 | 61.0s | 92.6s |
| Proxy step to first reasoning/sample | 105 | 0.0s | 1.0s |
| Job `activation` | 105 | 17.0s | 42.2s |
| Job `agent` | 105 | 40.0s | 51.0s |
| Job `detection` | 0 | n/a | n/a |
| Job `safe_outputs` | 105 | 12.0s | 21.6s |
| Job `conclusion` | 105 | 16.0s | 20.6s |
| Major step `Download container images` | 105 | 9.0s | 13.6s |
| Major step `Install ripgrep` | 3 | 9.0s | 21.8s |
| Major step `Start MCP Gateway` | 105 | 7.0s | 12.0s |
| Major step `Install GitHub Copilot CLI` | 105 | 4.0s | 5.0s |
| Major step `Set up job` | 89 | 2.0s | 5.0s |
| Major step `Setup Scripts` | 93 | 2.0s | 4.0s |
| Major step `Install AWF binary` | 7 | 2.0s | 2.4s |
| Major step `Download activation artifact` | 36 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 25 | 2.0s | 2.0s |
| Major step `Stop MCP Gateway` | 10 | 2.0s | 2.0s |
| Major step `Checkout repository` | 4 | 2.0s | 2.0s |

### Major step times for job `activation` (`released`, using samples)

![Major step times for activation, released, using samples](steps-activation-released-samples.svg)

#### Candidate regressions (last six weeks)

No candidate regressions in the last six weeks.

### Major step times for job `agent` (`released`, using samples)

![Major step times for agent, released, using samples](steps-agent-released-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-11 | Download container images | 27.0s | 12.0s | 125% | [#398](https://github.com/githubnext/gh-aw-test/actions/runs/32617180095) | `v0.86.2` / `48e5fa3ff522` |
| R2 | 2026-08-11 | Install GitHub Copilot CLI | 15.0s | 4.0s | 275% | [#398](https://github.com/githubnext/gh-aw-test/actions/runs/32617180095) | `v0.86.2` / `48e5fa3ff522` |
| R3 | 2026-08-22 | Install GitHub Copilot CLI | 20.0s | 5.0s | 300% | [#399](https://github.com/githubnext/gh-aw-test/actions/runs/32618677146) | `v0.87.4` / `83d6315352f7` |

### Major step times for job `detection` (`released`, using samples)

![Major step times for detection, released, using samples](steps-detection-released-samples.svg)

#### Candidate regressions (last six weeks)

No candidate regressions in the last six weeks.

### Major step times for job `safe_outputs` (`released`, using samples)

![Major step times for safe_outputs, released, using samples](steps-safe-outputs-released-samples.svg)

#### Candidate regressions (last six weeks)

No candidate regressions in the last six weeks.

### Major step times for job `conclusion` (`released`, using samples)

![Major step times for conclusion, released, using samples](steps-conclusion-released-samples.svg)

#### Candidate regressions (last six weeks)

No candidate regressions in the last six weeks.

## Method

Each section fixes both independent dimensions: gh-aw source (`main` or combined stable/pre-release `released`) and execution mode (`inference` or `samples`). Only overall-successful `workflow_dispatch` runs with a successful `agent` job are included. Candidate regression baselines use up to ten preceding observations from the same section and step; displayed regression episodes are limited to the six weeks before report generation. A step is graphed when it has a sustained cost, recent slowdown, or recent regression. Runs with missing compiler metadata remain in CSV/JSON but are excluded from graphs.

For inference runs, `Execute GitHub Copilot CLI` is additionally split using timestamped runtime markers: **AWF startup** is step start to the AWF agent-container entrypoint, **harness startup** is that entrypoint to the first Copilot process start, and **Copilot process** is the first process start through the final process close (including retries and retry delays). Cleanup after process close remains visible only in the full step duration, while unavailable markers produce no phase value.
