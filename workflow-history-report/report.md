# Performance history for `copilot-create-issue.md`

## Run, job & step times (`main`, using inference)

**97 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for main, using inference](timing-main-inference.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 97 | 338.0s | 441.0s |
| Workflow start to proxy step | 97 | 109.0s | 143.0s |
| Proxy step to first reasoning/sample | 89 | 19.9s | 24.9s |
| Copilot phase — AWF startup | 89 | 12.4s | 16.7s |
| Copilot phase — harness startup | 89 | 1.9s | 4.6s |
| Copilot phase — Copilot process | 89 | 7.9s | 10.0s |
| Job `activation` | 97 | 48.0s | 74.4s |
| Job `agent` | 97 | 91.0s | 174.6s |
| Job `detection` | 97 | 70.0s | 93.6s |
| Job `safe_outputs` | 97 | 38.0s | 62.8s |
| Job `conclusion` | 97 | 42.0s | 58.0s |
| Major step `Execute GitHub Copilot CLI` | 97 | 28.0s | 114.0s |
| Major step `Set up job` | 97 | 17.0s | 21.0s |
| Major step `Install ripgrep` | 6 | 14.0s | 19.0s |
| Major step `Download container images` | 97 | 11.0s | 18.4s |
| Major step `Start MCP Gateway` | 97 | 6.0s | 9.8s |
| Major step `Install GitHub Copilot CLI` | 97 | 4.0s | 9.0s |
| Major step `Setup Scripts` | 96 | 3.0s | 5.0s |
| Major step `Download activation artifact` | 50 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 35 | 2.0s | 2.0s |
| Major step `Checkout repository` | 20 | 2.0s | 2.0s |
| Major step `Install AWF binary` | 6 | 2.0s | 2.0s |
| Major step `Stop MCP Gateway` | 13 | 2.0s | 2.0s |
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

**37 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for released, using inference](timing-released-inference.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 37 | 220.0s | 332.6s |
| Workflow start to proxy step | 37 | 63.0s | 90.0s |
| Proxy step to first reasoning/sample | 34 | 21.4s | 28.8s |
| Copilot phase — AWF startup | 34 | 13.5s | 18.5s |
| Copilot phase — harness startup | 34 | 1.9s | 5.0s |
| Copilot phase — Copilot process | 34 | 7.8s | 8.8s |
| Job `activation` | 37 | 17.0s | 43.2s |
| Job `agent` | 37 | 74.0s | 157.4s |
| Job `detection` | 37 | 54.0s | 78.2s |
| Job `safe_outputs` | 37 | 12.0s | 17.6s |
| Job `conclusion` | 37 | 15.0s | 21.4s |
| Major step `Execute GitHub Copilot CLI` | 37 | 30.0s | 115.4s |
| Major step `Download container images` | 37 | 12.0s | 17.4s |
| Major step `Install ripgrep` | 3 | 12.0s | 14.4s |
| Major step `Start MCP Gateway` | 37 | 6.0s | 9.4s |
| Major step `Install GitHub Copilot CLI` | 37 | 4.0s | 9.4s |
| Major step `Set up job` | 35 | 3.0s | 4.0s |
| Major step `Setup Scripts` | 34 | 3.0s | 4.0s |
| Major step `Stop MCP Gateway` | 6 | 2.0s | 2.0s |
| Major step `Install AWF binary` | 3 | 2.0s | 2.0s |
| Major step `Download activation artifact` | 10 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 7 | 2.0s | 2.0s |
| Major step `Checkout repository` | 10 | 2.0s | 2.1s |

### Major step times for job `activation` (`released`, using inference)

![Major step times for activation, released, using inference](steps-activation-released-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-31 | Checkout .github and .agents folders | 17.0s | 2.0s | 750% | [#462](https://github.com/githubnext/gh-aw-test/actions/runs/33353384572) | `v0.87.10` / `ff62cdbec362` |
| R2 | 2026-08-31 | Set up job | 83.0s | 3.0s | 2667% | [#462](https://github.com/githubnext/gh-aw-test/actions/runs/33353384572) | `v0.87.10` / `ff62cdbec362` |
| R3 | 2026-08-31 | Setup Scripts | 16.0s | 3.0s | 433% | [#462](https://github.com/githubnext/gh-aw-test/actions/runs/33353384572) | `v0.87.10` / `ff62cdbec362` |

### Major step times for job `agent` (`released`, using inference)

![Major step times for agent, released, using inference](steps-agent-released-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-15 | Copilot phase — AWF startup | 23.5s | 13.2s | 79% | [#432](https://github.com/githubnext/gh-aw-test/actions/runs/32680559983) | `v0.86.3` / `6062cd2238b6` |
| R2 | 2026-08-31 | Copilot phase — AWF startup | 35.6s | 14.7s | 142% | [#462](https://github.com/githubnext/gh-aw-test/actions/runs/33353384572) | `v0.87.10` / `ff62cdbec362` |
| R3 | 2026-08-31 | Copilot phase — harness startup | 13.0s | 2.2s | 495% | [#462](https://github.com/githubnext/gh-aw-test/actions/runs/33353384572) | `v0.87.10` / `ff62cdbec362` |
| R4 | 2026-08-31 | Download container images | 46.0s | 9.5s | 384% | [#462](https://github.com/githubnext/gh-aw-test/actions/runs/33353384572) | `v0.87.10` / `ff62cdbec362` |
| R5 | 2026-08-31 | Execute GitHub Copilot CLI | 62.0s | 25.0s | 148% | [#462](https://github.com/githubnext/gh-aw-test/actions/runs/33353384572) | `v0.87.10` / `ff62cdbec362` |
| R6 | 2026-08-31 | Set up job | 29.0s | 3.0s | 867% | [#462](https://github.com/githubnext/gh-aw-test/actions/runs/33353384572) | `v0.87.10` / `ff62cdbec362` |
| R7 | 2026-08-31 | Start MCP Gateway | 23.0s | 6.5s | 254% | [#462](https://github.com/githubnext/gh-aw-test/actions/runs/33353384572) | `v0.87.10` / `ff62cdbec362` |

### Major step times for job `detection` (`released`, using inference)

![Major step times for detection, released, using inference](steps-detection-released-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-15 | Execute GitHub Copilot CLI | 36.0s | 23.5s | 53% | [#432](https://github.com/githubnext/gh-aw-test/actions/runs/32680559983) | `v0.86.3` / `6062cd2238b6` |
| R2 | 2026-08-31 | Set up job | 18.0s | 2.0s | 800% | [#462](https://github.com/githubnext/gh-aw-test/actions/runs/33353384572) | `v0.87.10` / `ff62cdbec362` |

### Major step times for job `safe_outputs` (`released`, using inference)

![Major step times for safe_outputs, released, using inference](steps-safe-outputs-released-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-31 | Set up job | 37.0s | 3.0s | 1133% | [#462](https://github.com/githubnext/gh-aw-test/actions/runs/33353384572) | `v0.87.10` / `ff62cdbec362` |

### Major step times for job `conclusion` (`released`, using inference)

![Major step times for conclusion, released, using inference](steps-conclusion-released-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-31 | Set up job | 27.0s | 2.5s | 980% | [#462](https://github.com/githubnext/gh-aw-test/actions/runs/33353384572) | `v0.87.10` / `ff62cdbec362` |

## Run, job & step times (`main`, using samples)

**90 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for main, using samples](timing-main-samples.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 90 | 190.0s | 240.5s |
| Workflow start to proxy step | 90 | 98.0s | 119.2s |
| Proxy step to first reasoning/sample | 90 | 0.0s | 1.0s |
| Job `activation` | 90 | 45.0s | 61.3s |
| Job `agent` | 90 | 43.5s | 56.1s |
| Job `detection` | 0 | n/a | n/a |
| Job `safe_outputs` | 90 | 31.0s | 43.1s |
| Job `conclusion` | 90 | 34.5s | 54.0s |
| Major step `Download container images` | 90 | 9.0s | 13.0s |
| Major step `Set up job` | 90 | 7.0s | 12.0s |
| Major step `Start MCP Gateway` | 90 | 6.0s | 11.0s |
| Major step `Install GitHub Copilot CLI` | 90 | 4.0s | 5.0s |
| Major step `Setup Scripts` | 88 | 2.0s | 4.0s |
| Major step `Checkout repository` | 15 | 2.0s | 2.0s |
| Major step `Install AWF binary` | 5 | 2.0s | 2.0s |
| Major step `Download activation artifact` | 26 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 15 | 2.0s | 2.0s |
| Major step `Stop MCP Gateway` | 9 | 2.0s | 2.0s |

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
| R1 | 2026-08-28 | Setup Scripts | 15.0s | 3.5s | 329% | [#454](https://github.com/githubnext/gh-aw-test/actions/runs/33146418391) | `76f6ea7c22` / `76f6ea7c2220` |

## Run, job & step times (`released`, using samples)

**150 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for released, using samples](timing-released-samples.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 150 | 117.0s | 160.1s |
| Workflow start to proxy step | 150 | 62.0s | 92.1s |
| Proxy step to first reasoning/sample | 150 | 0.0s | 1.0s |
| Job `activation` | 150 | 16.5s | 36.5s |
| Job `agent` | 150 | 40.5s | 54.0s |
| Job `detection` | 0 | n/a | n/a |
| Job `safe_outputs` | 150 | 12.0s | 22.0s |
| Job `conclusion` | 150 | 16.0s | 21.0s |
| Major step `Download container images` | 150 | 9.0s | 15.1s |
| Major step `Install ripgrep` | 9 | 9.0s | 17.0s |
| Major step `Start MCP Gateway` | 150 | 7.0s | 12.0s |
| Major step `Install GitHub Copilot CLI` | 150 | 4.0s | 8.1s |
| Major step `Set up job` | 124 | 3.0s | 5.7s |
| Major step `Setup Scripts` | 132 | 2.0s | 4.0s |
| Major step `Install AWF binary` | 10 | 2.0s | 2.1s |
| Major step `Download activation artifact` | 48 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 31 | 2.0s | 2.0s |
| Major step `Stop MCP Gateway` | 15 | 2.0s | 2.0s |
| Major step `Checkout repository` | 7 | 2.0s | 2.0s |

### Major step times for job `activation` (`released`, using samples)

![Major step times for activation, released, using samples](steps-activation-released-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-25 | Setup Scripts | 14.0s | 2.0s | 600% | [#452](https://github.com/githubnext/gh-aw-test/actions/runs/33044810016) | `v0.87.5` / `654cf351a595` |

### Major step times for job `agent` (`released`, using samples)

![Major step times for agent, released, using samples](steps-agent-released-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-22 | Install GitHub Copilot CLI | 20.0s | 10.0s | 100% | [#399](https://github.com/githubnext/gh-aw-test/actions/runs/32618677146) | `v0.87.4` / `83d6315352f7` |

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
