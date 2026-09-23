# Performance history for `copilot-create-issue.md`

## Run, job & step times (`main`, using inference)

**73 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for main, using inference](timing-main-inference.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 73 | 333.0s | 439.0s |
| Workflow start to proxy step | 73 | 108.0s | 142.8s |
| Proxy step to first reasoning/sample | 63 | 20.2s | 26.2s |
| Copilot phase — AWF startup | 63 | 13.0s | 16.7s |
| Copilot phase — harness startup | 63 | 1.9s | 4.6s |
| Copilot phase — Copilot process | 63 | 7.6s | 10.1s |
| Job `activation` | 73 | 47.0s | 73.6s |
| Job `agent` | 73 | 89.0s | 171.4s |
| Job `detection` | 73 | 72.0s | 96.8s |
| Job `safe_outputs` | 73 | 38.0s | 63.6s |
| Job `conclusion` | 73 | 42.0s | 59.6s |
| Major step `Execute GitHub Copilot CLI` | 73 | 28.0s | 113.8s |
| Major step `Set up job` | 73 | 17.0s | 21.0s |
| Major step `Install ripgrep` | 6 | 14.0s | 19.0s |
| Major step `Download container images` | 73 | 11.0s | 18.0s |
| Major step `Start MCP Gateway` | 73 | 6.0s | 11.0s |
| Major step `Install GitHub Copilot CLI` | 73 | 4.0s | 9.0s |
| Major step `Setup Scripts` | 72 | 3.0s | 5.0s |
| Major step `Download activation artifact` | 38 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 27 | 2.0s | 2.0s |
| Major step `Checkout repository` | 15 | 2.0s | 2.0s |
| Major step `Install AWF binary` | 4 | 2.0s | 2.0s |
| Major step `Stop MCP Gateway` | 9 | 2.0s | 2.0s |
| Major step `Print firewall logs` | 1 | 2.0s | 2.0s |
| Major step `Audit pre-agent workspace` | 1 | 2.0s | 2.0s |

### Major step times for job `activation` (`main`, using inference)

![Major step times for activation, main, using inference](steps-activation-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-17 | Set up job | 48.0s | 31.5s | 52% | [#352](https://github.com/githubnext/gh-aw-test/actions/runs/32558234273) | `v0.87.0-133-g2b2cf3fb01` / `2b2cf3fb01ee` |

### Major step times for job `agent` (`main`, using inference)

![Major step times for agent, main, using inference](steps-agent-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-14 | Copilot phase — AWF startup | 23.2s | 12.9s | 80% | [#349](https://github.com/githubnext/gh-aw-test/actions/runs/32556073604) | `v0.86.2-73-gc35faf436c` / `c35faf436c79` |
| R2 | 2026-08-14 | Execute GitHub Copilot CLI | 38.0s | 23.0s | 65% | [#349](https://github.com/githubnext/gh-aw-test/actions/runs/32556073604) | `v0.86.2-73-gc35faf436c` / `c35faf436c79` |

### Major step times for job `detection` (`main`, using inference)

![Major step times for detection, main, using inference](steps-detection-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-18 | Execute GitHub Copilot CLI | 50.0s | 31.5s | 59% | [#353](https://github.com/githubnext/gh-aw-test/actions/runs/32558698273) | `v0.87.1-4-g4845f00caf` / `4845f00caf46` |
| R2 | 2026-08-24 | Download container images | 12.0s | 1.0s | 1100% | [#437](https://github.com/githubnext/gh-aw-test/actions/runs/32686470697) | `5f0cc8dcc8` / `5f0cc8dcc819` |

### Major step times for job `safe_outputs` (`main`, using inference)

![Major step times for safe_outputs, main, using inference](steps-safe-outputs-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-14 to 2026-08-16 | Set up job | 69.0s | 29.0s | 138% | [#349](https://github.com/githubnext/gh-aw-test/actions/runs/32556073604) | `v0.86.2-73-gc35faf436c` / `c35faf436c79` |
| R2 | 2026-08-25 | Download agent output artifact | 12.0s | 1.0s | 1100% | [#445](https://github.com/githubnext/gh-aw-test/actions/runs/32926588860) | `818e3a3863` / `818e3a386376` |

### Major step times for job `conclusion` (`main`, using inference)

![Major step times for conclusion, main, using inference](steps-conclusion-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-17 | Upload usage artifact | 11.0s | 1.0s | 1000% | [#352](https://github.com/githubnext/gh-aw-test/actions/runs/32558234273) | `v0.87.0-133-g2b2cf3fb01` / `2b2cf3fb01ee` |
| R2 | 2026-08-19 | Set up job | 48.0s | 28.0s | 71% | [#354](https://github.com/githubnext/gh-aw-test/actions/runs/32559121042) | `v0.87.1-44-g5d5e0af5c4` / `5d5e0af5c46c` |

## Run, job & step times (`released`, using inference)

**36 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for released, using inference](timing-released-inference.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 36 | 217.0s | 309.5s |
| Workflow start to proxy step | 36 | 62.0s | 89.5s |
| Proxy step to first reasoning/sample | 33 | 21.2s | 27.8s |
| Copilot phase — AWF startup | 33 | 13.3s | 17.9s |
| Copilot phase — harness startup | 33 | 1.9s | 4.1s |
| Copilot phase — Copilot process | 33 | 7.7s | 8.7s |
| Job `activation` | 36 | 17.0s | 35.0s |
| Job `agent` | 36 | 73.0s | 157.0s |
| Job `detection` | 36 | 53.5s | 72.5s |
| Job `safe_outputs` | 36 | 12.0s | 14.0s |
| Job `conclusion` | 36 | 14.5s | 20.5s |
| Major step `Execute GitHub Copilot CLI` | 36 | 29.5s | 115.5s |
| Major step `Download container images` | 36 | 12.0s | 17.0s |
| Major step `Install ripgrep` | 3 | 12.0s | 14.4s |
| Major step `Start MCP Gateway` | 36 | 6.0s | 8.5s |
| Major step `Install GitHub Copilot CLI` | 36 | 4.0s | 8.5s |
| Major step `Set up job` | 34 | 3.0s | 4.0s |
| Major step `Setup Scripts` | 33 | 3.0s | 4.0s |
| Major step `Stop MCP Gateway` | 5 | 2.0s | 2.0s |
| Major step `Install AWF binary` | 3 | 2.0s | 2.0s |
| Major step `Download activation artifact` | 10 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 7 | 2.0s | 2.0s |
| Major step `Checkout repository` | 9 | 2.0s | 2.2s |

### Major step times for job `activation` (`released`, using inference)

![Major step times for activation, released, using inference](steps-activation-released-inference.svg)

#### Candidate regressions (last six weeks)

No candidate regressions in the last six weeks.

### Major step times for job `agent` (`released`, using inference)

![Major step times for agent, released, using inference](steps-agent-released-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-15 | Copilot phase — AWF startup | 23.5s | 13.2s | 79% | [#432](https://github.com/githubnext/gh-aw-test/actions/runs/32680559983) | `v0.86.3` / `6062cd2238b6` |

### Major step times for job `detection` (`released`, using inference)

![Major step times for detection, released, using inference](steps-detection-released-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-15 | Execute GitHub Copilot CLI | 36.0s | 23.5s | 53% | [#432](https://github.com/githubnext/gh-aw-test/actions/runs/32680559983) | `v0.86.3` / `6062cd2238b6` |

### Major step times for job `safe_outputs` (`released`, using inference)

![Major step times for safe_outputs, released, using inference](steps-safe-outputs-released-inference.svg)

#### Candidate regressions (last six weeks)

No candidate regressions in the last six weeks.

### Major step times for job `conclusion` (`released`, using inference)

![Major step times for conclusion, released, using inference](steps-conclusion-released-inference.svg)

#### Candidate regressions (last six weeks)

No candidate regressions in the last six weeks.

## Run, job & step times (`main`, using samples)

**80 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for main, using samples](timing-main-samples.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 80 | 190.0s | 240.5s |
| Workflow start to proxy step | 80 | 98.0s | 121.0s |
| Proxy step to first reasoning/sample | 80 | 0.0s | 1.0s |
| Job `activation` | 80 | 44.0s | 64.0s |
| Job `agent` | 80 | 45.0s | 56.1s |
| Job `detection` | 0 | n/a | n/a |
| Job `safe_outputs` | 80 | 31.0s | 42.1s |
| Job `conclusion` | 80 | 33.5s | 54.6s |
| Major step `Download container images` | 80 | 9.0s | 12.1s |
| Major step `Set up job` | 80 | 7.0s | 12.0s |
| Major step `Start MCP Gateway` | 80 | 7.0s | 12.0s |
| Major step `Install GitHub Copilot CLI` | 80 | 4.0s | 5.0s |
| Major step `Setup Scripts` | 79 | 2.0s | 4.2s |
| Major step `Checkout repository` | 13 | 2.0s | 2.0s |
| Major step `Install AWF binary` | 5 | 2.0s | 2.0s |
| Major step `Download activation artifact` | 25 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 16 | 2.0s | 2.0s |
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

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-24 | Set up job | 54.0s | 27.5s | 96% | [#438](https://github.com/githubnext/gh-aw-test/actions/runs/32686992371) | `5f0cc8dcc8` / `5f0cc8dcc819` |

### Major step times for job `conclusion` (`main`, using samples)

![Major step times for conclusion, main, using samples](steps-conclusion-main-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-28 | Setup Scripts | 15.0s | 3.0s | 400% | [#454](https://github.com/githubnext/gh-aw-test/actions/runs/33146418391) | `76f6ea7c22` / `76f6ea7c2220` |

## Run, job & step times (`released`, using samples)

**115 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for released, using samples](timing-released-samples.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 115 | 114.0s | 159.2s |
| Workflow start to proxy step | 115 | 61.0s | 92.0s |
| Proxy step to first reasoning/sample | 115 | 0.0s | 1.0s |
| Job `activation` | 115 | 17.0s | 39.0s |
| Job `agent` | 115 | 40.0s | 52.0s |
| Job `detection` | 0 | n/a | n/a |
| Job `safe_outputs` | 115 | 12.0s | 21.6s |
| Job `conclusion` | 115 | 16.0s | 20.0s |
| Major step `Download container images` | 115 | 9.0s | 13.0s |
| Major step `Install ripgrep` | 8 | 9.0s | 18.0s |
| Major step `Start MCP Gateway` | 115 | 7.0s | 12.0s |
| Major step `Install GitHub Copilot CLI` | 115 | 4.0s | 10.0s |
| Major step `Set up job` | 96 | 2.0s | 4.5s |
| Major step `Setup Scripts` | 103 | 2.0s | 4.0s |
| Major step `Install AWF binary` | 7 | 2.0s | 2.4s |
| Major step `Download activation artifact` | 39 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 27 | 2.0s | 2.0s |
| Major step `Stop MCP Gateway` | 11 | 2.0s | 2.0s |
| Major step `Checkout repository` | 5 | 2.0s | 2.0s |

### Major step times for job `activation` (`released`, using samples)

![Major step times for activation, released, using samples](steps-activation-released-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-25 | Setup Scripts | 14.0s | 2.5s | 460% | [#452](https://github.com/githubnext/gh-aw-test/actions/runs/33044810016) | `v0.87.5` / `654cf351a595` |

### Major step times for job `agent` (`released`, using samples)

![Major step times for agent, released, using samples](steps-agent-released-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-22 | Install GitHub Copilot CLI | 20.0s | 9.5s | 111% | [#399](https://github.com/githubnext/gh-aw-test/actions/runs/32618677146) | `v0.87.4` / `83d6315352f7` |

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
