# Performance history for `copilot-create-issue.md`

## Run, job & step times (`main`, using inference)

**90 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for main, using inference](timing-main-inference.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 90 | 342.0s | 441.0s |
| Workflow start to proxy step | 90 | 112.5s | 148.1s |
| Proxy step to first reasoning/sample | 88 | 20.9s | 27.0s |
| Copilot phase — AWF startup | 88 | 14.1s | 18.7s |
| Copilot phase — harness startup | 88 | 2.0s | 4.6s |
| Copilot phase — Copilot process | 88 | 7.1s | 10.2s |
| Job `activation` | 90 | 48.0s | 75.2s |
| Job `agent` | 90 | 89.0s | 169.0s |
| Job `detection` | 90 | 74.0s | 96.0s |
| Job `safe_outputs` | 90 | 39.0s | 67.2s |
| Job `conclusion` | 90 | 44.0s | 62.3s |
| Major step `Execute GitHub Copilot CLI` | 90 | 27.5s | 113.0s |
| Major step `Set up job` | 90 | 17.0s | 22.0s |
| Major step `Install ripgrep` | 6 | 14.0s | 19.0s |
| Major step `Download container images` | 90 | 11.0s | 18.0s |
| Major step `Start MCP Gateway` | 90 | 6.0s | 10.1s |
| Major step `Install GitHub Copilot CLI` | 90 | 4.0s | 10.0s |
| Major step `Setup Scripts` | 89 | 3.0s | 5.0s |
| Major step `Download activation artifact` | 40 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 28 | 2.0s | 2.0s |
| Major step `Checkout repository` | 18 | 2.0s | 2.0s |
| Major step `Install AWF binary` | 5 | 2.0s | 2.0s |
| Major step `Stop MCP Gateway` | 10 | 2.0s | 2.0s |
| Major step `Print firewall logs` | 1 | 2.0s | 2.0s |
| Major step `Audit pre-agent workspace` | 1 | 2.0s | 2.0s |
| Major step `Upload agent output fallback artifact` | 2 | 2.0s | 2.0s |

### Major step times for job `activation` (`main`, using inference)

![Major step times for activation, main, using inference](steps-activation-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-08 | Set up job | 63.0s | 34.5s | 83% | [#341](https://github.com/githubnext/gh-aw-test/actions/runs/32552452139) | `v0.86.1-57-gba0a9f9589` / `ba0a9f958976` |
| R2 | 2026-08-08 | Setup Scripts | 18.0s | 3.0s | 500% | [#341](https://github.com/githubnext/gh-aw-test/actions/runs/32552452139) | `v0.86.1-57-gba0a9f9589` / `ba0a9f958976` |
| R3 | 2026-08-17 | Set up job | 48.0s | 31.5s | 52% | [#352](https://github.com/githubnext/gh-aw-test/actions/runs/32558234273) | `v0.87.0-133-g2b2cf3fb01` / `2b2cf3fb01ee` |
| R4 | 2026-09-12 to 2026-09-16 | Set up job | 72.0s | 36.0s | 100% | [#517](https://github.com/githubnext/gh-aw-test/actions/runs/34811072379) | `aa0cabfb25` / `aa0cabfb259e` |

### Major step times for job `agent` (`main`, using inference)

![Major step times for agent, main, using inference](steps-agent-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-07 | Download container images | 24.0s | 11.0s | 118% | [#340](https://github.com/githubnext/gh-aw-test/actions/runs/32552050221) | `v0.86.1-3-ge1e298d64b` / `e1e298d64bfa` |
| R2 | 2026-08-07 | Execute GitHub Copilot CLI | 38.0s | 22.5s | 69% | [#340](https://github.com/githubnext/gh-aw-test/actions/runs/32552050221) | `v0.86.1-3-ge1e298d64b` / `e1e298d64bfa` |
| R3 | 2026-08-14 | Copilot phase — AWF startup | 23.2s | 12.9s | 80% | [#349](https://github.com/githubnext/gh-aw-test/actions/runs/32556073604) | `v0.86.2-73-gc35faf436c` / `c35faf436c79` |
| R4 | 2026-08-14 | Execute GitHub Copilot CLI | 38.0s | 23.0s | 65% | [#349](https://github.com/githubnext/gh-aw-test/actions/runs/32556073604) | `v0.86.2-73-gc35faf436c` / `c35faf436c79` |
| R5 | 2026-09-02 | Copilot phase — AWF startup | 27.9s | 14.9s | 87% | [#470](https://github.com/githubnext/gh-aw-test/actions/runs/33586531796) | `bde2c79aa0` / `bde2c79aa0d6` |
| R6 | 2026-09-02 | Download container images | 24.0s | 9.5s | 153% | [#470](https://github.com/githubnext/gh-aw-test/actions/runs/33586531796) | `bde2c79aa0` / `bde2c79aa0d6` |
| R7 | 2026-09-02 | Execute GitHub Copilot CLI | 47.0s | 24.0s | 96% | [#470](https://github.com/githubnext/gh-aw-test/actions/runs/33586531796) | `bde2c79aa0` / `bde2c79aa0d6` |
| R8 | 2026-09-05 | Install GitHub Copilot CLI | 20.0s | 9.0s | 122% | [#481](https://github.com/githubnext/gh-aw-test/actions/runs/33941353410) | `5473143ca3` / `5473143ca3ae` |

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
| R3 | 2026-09-07 | Set up job | 70.0s | 34.0s | 106% | [#486](https://github.com/githubnext/gh-aw-test/actions/runs/34079107256) | `e79e3685c1` / `e79e3685c126` |
| R4 | 2026-09-11 | Set up job | 70.0s | 35.5s | 97% | [#502](https://github.com/githubnext/gh-aw-test/actions/runs/34557783678) | `1787de5150` / `1787de5150ac` |
| R5 | 2026-09-14 to 2026-09-16 | Set up job | 79.0s | 32.5s | 143% | [#529](https://github.com/githubnext/gh-aw-test/actions/runs/35074766458) | `0fea86e118` / `0fea86e1185f` |

### Major step times for job `conclusion` (`main`, using inference)

![Major step times for conclusion, main, using inference](steps-conclusion-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-17 | Upload usage artifact | 11.0s | 1.0s | 1000% | [#352](https://github.com/githubnext/gh-aw-test/actions/runs/32558234273) | `v0.87.0-133-g2b2cf3fb01` / `2b2cf3fb01ee` |
| R2 | 2026-08-19 | Set up job | 48.0s | 28.0s | 71% | [#354](https://github.com/githubnext/gh-aw-test/actions/runs/32559121042) | `v0.87.1-44-g5d5e0af5c4` / `5d5e0af5c46c` |
| R3 | 2026-09-16 | Setup Scripts | 16.0s | 3.0s | 433% | [#529](https://github.com/githubnext/gh-aw-test/actions/runs/35074766458) | `0fea86e118` / `0fea86e1185f` |
| R4 | 2026-09-17 | Set up job | 112.0s | 40.0s | 180% | [#531](https://github.com/githubnext/gh-aw-test/actions/runs/35177511214) | `290730bc39` / `290730bc3932` |

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
| R1 | 2026-08-07 | Install GitHub Copilot CLI | 15.0s | 4.0s | 275% | [#430](https://github.com/githubnext/gh-aw-test/actions/runs/32679960433) | `v0.86.1` / `475927dfc6d1` |
| R2 | 2026-08-15 | Execute GitHub Copilot CLI | 36.0s | 23.5s | 53% | [#432](https://github.com/githubnext/gh-aw-test/actions/runs/32680559983) | `v0.86.3` / `6062cd2238b6` |
| R3 | 2026-08-31 | Set up job | 18.0s | 2.0s | 800% | [#462](https://github.com/githubnext/gh-aw-test/actions/runs/33353384572) | `v0.87.10` / `ff62cdbec362` |

### Major step times for job `safe_outputs` (`released`, using inference)

![Major step times for safe_outputs, released, using inference](steps-safe-outputs-released-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-07 | Setup Scripts | 20.0s | 2.0s | 900% | [#430](https://github.com/githubnext/gh-aw-test/actions/runs/32679960433) | `v0.86.1` / `475927dfc6d1` |
| R2 | 2026-08-31 | Set up job | 37.0s | 3.0s | 1133% | [#462](https://github.com/githubnext/gh-aw-test/actions/runs/33353384572) | `v0.87.10` / `ff62cdbec362` |

### Major step times for job `conclusion` (`released`, using inference)

![Major step times for conclusion, released, using inference](steps-conclusion-released-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-31 | Set up job | 27.0s | 2.5s | 980% | [#462](https://github.com/githubnext/gh-aw-test/actions/runs/33353384572) | `v0.87.10` / `ff62cdbec362` |

## Run, job & step times (`main`, using samples)

**83 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for main, using samples](timing-main-samples.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 83 | 202.0s | 267.0s |
| Workflow start to proxy step | 83 | 100.0s | 131.6s |
| Proxy step to first reasoning/sample | 83 | 0.0s | 0.8s |
| Job `activation` | 83 | 46.0s | 71.8s |
| Job `agent` | 83 | 45.0s | 57.0s |
| Job `detection` | 0 | n/a | n/a |
| Job `safe_outputs` | 83 | 32.0s | 55.6s |
| Job `conclusion` | 83 | 38.0s | 64.4s |
| Major step `Download container images` | 83 | 9.0s | 13.0s |
| Major step `Set up job` | 83 | 8.0s | 12.0s |
| Major step `Start MCP Gateway` | 83 | 6.0s | 11.0s |
| Major step `Print firewall logs` | 1 | 5.0s | 5.0s |
| Major step `Install GitHub Copilot CLI` | 83 | 4.0s | 9.0s |
| Major step `Setup Scripts` | 82 | 3.0s | 4.0s |
| Major step `Checkout repository` | 15 | 2.0s | 2.0s |
| Major step `Install AWF binary` | 3 | 2.0s | 2.0s |
| Major step `Download activation artifact` | 26 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 15 | 2.0s | 2.0s |
| Major step `Stop MCP Gateway` | 9 | 2.0s | 2.0s |
| Major step `Upload agent output fallback artifact` | 2 | 2.0s | 2.0s |

### Major step times for job `activation` (`main`, using samples)

![Major step times for activation, main, using samples](steps-activation-main-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-01 | Set up job | 71.0s | 32.0s | 122% | [#467](https://github.com/githubnext/gh-aw-test/actions/runs/33466354665) | `4a88fd99c3` / `4a88fd99c35f` |
| R2 | 2026-09-05 | Set up job | 73.0s | 33.0s | 121% | [#482](https://github.com/githubnext/gh-aw-test/actions/runs/33941860161) | `5473143ca3` / `5473143ca3ae` |
| R3 | 2026-09-10 | Setup Scripts | 15.0s | 4.5s | 233% | [#499](https://github.com/githubnext/gh-aw-test/actions/runs/34433325600) | `099efdda60` / `099efdda60fe` |
| R4 | 2026-09-14 to 2026-09-15 | Set up job | 111.0s | 34.5s | 222% | [#526](https://github.com/githubnext/gh-aw-test/actions/runs/35051876292) | `ac594b6525` / `ac594b6525e3` |
| R5 | 2026-09-15 | Checkout .github and .agents folders | 13.0s | 2.0s | 550% | [#526](https://github.com/githubnext/gh-aw-test/actions/runs/35051876292) | `ac594b6525` / `ac594b6525e3` |

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
| R2 | 2026-09-04 to 2026-09-10 | Set up job | 98.0s | 24.5s | 300% | [#491](https://github.com/githubnext/gh-aw-test/actions/runs/34183526364) | `4fbd3efbb3` / `4fbd3efbb3c2` |
| R3 | 2026-09-10 | Setup Scripts | 16.0s | 6.0s | 167% | [#499](https://github.com/githubnext/gh-aw-test/actions/runs/34433325600) | `099efdda60` / `099efdda60fe` |
| R4 | 2026-09-15 | Set up job | 87.0s | 38.0s | 129% | [#526](https://github.com/githubnext/gh-aw-test/actions/runs/35051876292) | `ac594b6525` / `ac594b6525e3` |

### Major step times for job `conclusion` (`main`, using samples)

![Major step times for conclusion, main, using samples](steps-conclusion-main-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-28 | Setup Scripts | 15.0s | 3.0s | 400% | [#454](https://github.com/githubnext/gh-aw-test/actions/runs/33146418391) | `76f6ea7c22` / `76f6ea7c2220` |
| R2 | 2026-09-04 | Set up job | 42.0s | 24.5s | 71% | [#478](https://github.com/githubnext/gh-aw-test/actions/runs/33833352495) | `76182db3ee` / `76182db3eedf` |
| R3 | 2026-09-08 to 2026-09-09 | Set up job | 98.0s | 27.0s | 263% | [#491](https://github.com/githubnext/gh-aw-test/actions/runs/34183526364) | `4fbd3efbb3` / `4fbd3efbb3c2` |
| R4 | 2026-09-13 to 2026-09-18 | Set up job | 70.0s | 34.0s | 106% | [#526](https://github.com/githubnext/gh-aw-test/actions/runs/35051876292) | `ac594b6525` / `ac594b6525e3` |

## Run, job & step times (`released`, using samples)

**138 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for released, using samples](timing-released-samples.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 138 | 128.0s | 178.3s |
| Workflow start to proxy step | 138 | 67.5s | 97.3s |
| Proxy step to first reasoning/sample | 138 | 0.0s | 1.0s |
| Job `activation` | 138 | 18.0s | 39.6s |
| Job `agent` | 138 | 41.0s | 57.3s |
| Job `detection` | 0 | n/a | n/a |
| Job `safe_outputs` | 138 | 13.0s | 23.0s |
| Job `conclusion` | 138 | 16.0s | 27.0s |
| Major step `Download container images` | 138 | 9.0s | 17.3s |
| Major step `Install ripgrep` | 8 | 9.0s | 18.0s |
| Major step `Start MCP Gateway` | 138 | 7.0s | 12.0s |
| Major step `Install GitHub Copilot CLI` | 138 | 4.0s | 10.0s |
| Major step `Set up job` | 116 | 3.0s | 5.0s |
| Major step `Setup Scripts` | 125 | 2.0s | 4.0s |
| Major step `Install AWF binary` | 10 | 2.0s | 2.1s |
| Major step `Download activation artifact` | 45 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 25 | 2.0s | 2.0s |
| Major step `Stop MCP Gateway` | 19 | 2.0s | 2.0s |
| Major step `Checkout repository` | 11 | 2.0s | 2.0s |
| Major step `Upload agent output fallback artifact` | 2 | 2.0s | 2.0s |

### Major step times for job `activation` (`released`, using samples)

![Major step times for activation, released, using samples](steps-activation-released-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-25 | Setup Scripts | 14.0s | 2.5s | 460% | [#452](https://github.com/githubnext/gh-aw-test/actions/runs/33044810016) | `v0.87.5` / `654cf351a595` |
| R2 | 2026-08-31 | Set up job | 58.0s | 3.0s | 1833% | [#463](https://github.com/githubnext/gh-aw-test/actions/runs/33354115383) | `v0.87.10` / `ff62cdbec362` |
| R3 | 2026-08-31 | Setup Scripts | 21.0s | 2.0s | 950% | [#463](https://github.com/githubnext/gh-aw-test/actions/runs/33354115383) | `v0.87.10` / `ff62cdbec362` |
| R4 | 2026-09-03 | Set up job | 14.0s | 3.0s | 367% | [#475](https://github.com/githubnext/gh-aw-test/actions/runs/33716003352) | `v0.88.2` / `8e30bcd8897f` |
| R5 | 2026-09-08 | Checkout .github and .agents folders | 18.0s | 2.0s | 800% | [#500](https://github.com/githubnext/gh-aw-test/actions/runs/34435478909) | `v0.88.7` / `bde367913ade` |
| R6 | 2026-09-08 | Setup Scripts | 18.0s | 2.0s | 800% | [#504](https://github.com/githubnext/gh-aw-test/actions/runs/34560707477) | `v0.88.7` / `bde367913ade` |
| R7 | 2026-09-08 | Upload activation artifact | 17.0s | 2.0s | 750% | [#515](https://github.com/githubnext/gh-aw-test/actions/runs/34804532324) | `v0.88.7` / `bde367913ade` |
| R8 | 2026-09-14 | Set up job | 41.0s | 5.0s | 720% | [#524](https://github.com/githubnext/gh-aw-test/actions/runs/34929217400) | `v0.89.15` / `0fac96fb53dc` |
| R9 | 2026-09-14 | Setup Scripts | 18.0s | 2.0s | 800% | [#524](https://github.com/githubnext/gh-aw-test/actions/runs/34929217400) | `v0.89.15` / `0fac96fb53dc` |

### Major step times for job `agent` (`released`, using samples)

![Major step times for agent, released, using samples](steps-agent-released-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-11 | Download container images | 27.0s | 12.0s | 125% | [#398](https://github.com/githubnext/gh-aw-test/actions/runs/32617180095) | `v0.86.2` / `48e5fa3ff522` |
| R2 | 2026-08-11 | Install GitHub Copilot CLI | 15.0s | 4.0s | 275% | [#398](https://github.com/githubnext/gh-aw-test/actions/runs/32617180095) | `v0.86.2` / `48e5fa3ff522` |
| R3 | 2026-08-22 | Install GitHub Copilot CLI | 20.0s | 9.0s | 122% | [#399](https://github.com/githubnext/gh-aw-test/actions/runs/32618677146) | `v0.87.4` / `83d6315352f7` |
| R4 | 2026-08-31 | Download container images | 20.0s | 9.0s | 122% | [#465](https://github.com/githubnext/gh-aw-test/actions/runs/33357286535) | `v0.87.10` / `ff62cdbec362` |
| R5 | 2026-08-31 | Install GitHub Copilot CLI | 28.0s | 9.5s | 195% | [#468](https://github.com/githubnext/gh-aw-test/actions/runs/33468386886) | `v0.87.10` / `ff62cdbec362` |
| R6 | 2026-08-31 | Set up job | 13.0s | 2.0s | 550% | [#463](https://github.com/githubnext/gh-aw-test/actions/runs/33354115383) | `v0.87.10` / `ff62cdbec362` |
| R7 | 2026-09-03 | Download container images | 22.0s | 11.5s | 91% | [#492](https://github.com/githubnext/gh-aw-test/actions/runs/34185562905) | `v0.88.2` / `8e30bcd8897f` |
| R8 | 2026-09-04 | Install GitHub Copilot CLI | 29.0s | 10.0s | 190% | [#489](https://github.com/githubnext/gh-aw-test/actions/runs/34083680068) | `v0.88.4` / `82239c030d6a` |
| R9 | 2026-09-11 to 2026-09-14 | Download container images | 18.0s | 5.5s | 227% | [#508](https://github.com/githubnext/gh-aw-test/actions/runs/34671669720) | `v0.89.7` / `93c3fc498dbd` |

### Major step times for job `detection` (`released`, using samples)

![Major step times for detection, released, using samples](steps-detection-released-samples.svg)

#### Candidate regressions (last six weeks)

No candidate regressions in the last six weeks.

### Major step times for job `safe_outputs` (`released`, using samples)

![Major step times for safe_outputs, released, using samples](steps-safe-outputs-released-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-31 | Set up job | 14.0s | 2.0s | 600% | [#463](https://github.com/githubnext/gh-aw-test/actions/runs/33354115383) | `v0.87.10` / `ff62cdbec362` |
| R2 | 2026-09-03 | Set up job | 18.0s | 2.5s | 620% | [#475](https://github.com/githubnext/gh-aw-test/actions/runs/33716003352) | `v0.88.2` / `8e30bcd8897f` |
| R3 | 2026-09-07 to 2026-09-08 | Set up job | 24.0s | 3.5s | 586% | [#537](https://github.com/githubnext/gh-aw-test/actions/runs/35305388904) | `v0.88.7` / `bde367913ade` |
| R4 | 2026-09-13 | Set up job | 18.0s | 5.5s | 227% | [#516](https://github.com/githubnext/gh-aw-test/actions/runs/34806250484) | `v0.89.12` / `3c53578b6037` |

### Major step times for job `conclusion` (`released`, using samples)

![Major step times for conclusion, released, using samples](steps-conclusion-released-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-31 | Set up job | 67.0s | 2.0s | 3250% | [#463](https://github.com/githubnext/gh-aw-test/actions/runs/33354115383) | `v0.87.10` / `ff62cdbec362` |
| R2 | 2026-09-03 | Set up job | 34.0s | 2.0s | 1600% | [#475](https://github.com/githubnext/gh-aw-test/actions/runs/33716003352) | `v0.88.2` / `8e30bcd8897f` |
| R3 | 2026-09-08 | Set up job | 28.0s | 6.0s | 367% | [#496](https://github.com/githubnext/gh-aw-test/actions/runs/34309466322) | `v0.88.7` / `bde367913ade` |
| R4 | 2026-09-08 | Setup Scripts | 16.0s | 2.0s | 700% | [#527](https://github.com/githubnext/gh-aw-test/actions/runs/35054650339) | `v0.88.7` / `bde367913ade` |
| R5 | 2026-09-13 | Set up job | 48.0s | 6.5s | 638% | [#520](https://github.com/githubnext/gh-aw-test/actions/runs/34816201643) | `v0.89.12` / `3c53578b6037` |

## Method

Each section fixes both independent dimensions: gh-aw source (`main` or combined stable/pre-release `released`) and execution mode (`inference` or `samples`). Only overall-successful `workflow_dispatch` runs with a successful `agent` job are included. Candidate regression baselines use up to ten preceding observations from the same section and step; displayed regression episodes are limited to the six weeks before report generation. A step is graphed when it has a sustained cost, recent slowdown, or recent regression. Runs with missing compiler metadata remain in CSV/JSON but are excluded from graphs.

For inference runs, `Execute GitHub Copilot CLI` is additionally split using timestamped runtime markers: **AWF startup** is step start to the AWF agent-container entrypoint, **harness startup** is that entrypoint to the first Copilot process start, and **Copilot process** is the first process start through the final process close (including retries and retry delays). Cleanup after process close remains visible only in the full step duration, while unavailable markers produce no phase value.
