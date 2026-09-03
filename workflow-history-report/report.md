# Performance history for `copilot-create-issue.md`

## Run, job & step times (`main`, using inference)

**72 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for main, using inference](timing-main-inference.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 72 | 335.0s | 440.0s |
| Workflow start to proxy step | 72 | 108.5s | 142.9s |
| Proxy step to first reasoning/sample | 72 | 20.6s | 27.5s |
| Copilot phase — AWF startup | 72 | 13.9s | 17.6s |
| Copilot phase — harness startup | 72 | 2.1s | 4.9s |
| Copilot phase — Copilot process | 72 | 8.2s | 10.6s |
| Job `activation` | 72 | 46.5s | 73.8s |
| Job `agent` | 72 | 89.0s | 171.7s |
| Job `detection` | 72 | 72.5s | 96.0s |
| Job `safe_outputs` | 72 | 38.0s | 63.8s |
| Job `conclusion` | 72 | 42.0s | 59.8s |
| Major step `Execute GitHub Copilot CLI` | 72 | 28.0s | 113.9s |
| Major step `Set up job` | 72 | 17.0s | 21.9s |
| Major step `Install ripgrep` | 6 | 14.0s | 19.0s |
| Major step `Download container images` | 72 | 11.0s | 18.9s |
| Major step `Start MCP Gateway` | 72 | 6.0s | 10.8s |
| Major step `Install GitHub Copilot CLI` | 72 | 4.0s | 9.0s |
| Major step `Setup Scripts` | 71 | 3.0s | 5.0s |
| Major step `Download activation artifact` | 36 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 25 | 2.0s | 2.0s |
| Major step `Checkout repository` | 16 | 2.0s | 2.0s |
| Major step `Install AWF binary` | 5 | 2.0s | 2.0s |
| Major step `Stop MCP Gateway` | 9 | 2.0s | 2.0s |
| Major step `Print firewall logs` | 1 | 2.0s | 2.0s |
| Major step `Audit pre-agent workspace` | 1 | 2.0s | 2.0s |

### Major step times for job `activation` (`main`, using inference)

![Major step times for activation, main, using inference](steps-activation-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-07-25 to 2026-07-27 | Set up job | 75.0s | 29.5s | 154% | [#325](https://github.com/githubnext/gh-aw-test/actions/runs/32542948173) | `v0.83.3-17-g11d9ea9de7` / `11d9ea9de729` |
| R2 | 2026-08-08 | Set up job | 63.0s | 34.5s | 83% | [#341](https://github.com/githubnext/gh-aw-test/actions/runs/32552452139) | `v0.86.1-57-gba0a9f9589` / `ba0a9f958976` |
| R3 | 2026-08-08 | Setup Scripts | 18.0s | 3.0s | 500% | [#341](https://github.com/githubnext/gh-aw-test/actions/runs/32552452139) | `v0.86.1-57-gba0a9f9589` / `ba0a9f958976` |
| R4 | 2026-08-17 | Set up job | 48.0s | 31.5s | 52% | [#352](https://github.com/githubnext/gh-aw-test/actions/runs/32558234273) | `v0.87.0-133-g2b2cf3fb01` / `2b2cf3fb01ee` |

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
| R1 | 2026-07-25 | Set up job | 61.0s | 25.5s | 139% | [#325](https://github.com/githubnext/gh-aw-test/actions/runs/32542948173) | `v0.83.3-17-g11d9ea9de7` / `11d9ea9de729` |
| R2 | 2026-08-01 to 2026-08-03 | Set up job | 89.0s | 34.5s | 158% | [#334](https://github.com/githubnext/gh-aw-test/actions/runs/32547543586) | `v0.84.3-58-g53baccde53` / `53baccde5390` |
| R3 | 2026-08-03 | Setup Scripts | 41.0s | 4.5s | 811% | [#334](https://github.com/githubnext/gh-aw-test/actions/runs/32547543586) | `v0.84.3-58-g53baccde53` / `53baccde5390` |
| R4 | 2026-08-14 to 2026-08-16 | Set up job | 69.0s | 29.0s | 138% | [#349](https://github.com/githubnext/gh-aw-test/actions/runs/32556073604) | `v0.86.2-73-gc35faf436c` / `c35faf436c79` |
| R5 | 2026-08-25 | Download agent output artifact | 12.0s | 1.0s | 1100% | [#445](https://github.com/githubnext/gh-aw-test/actions/runs/32926588860) | `818e3a3863` / `818e3a386376` |

### Major step times for job `conclusion` (`main`, using inference)

![Major step times for conclusion, main, using inference](steps-conclusion-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-07-30 to 2026-08-02 | Set up job | 59.0s | 29.5s | 100% | [#333](https://github.com/githubnext/gh-aw-test/actions/runs/32547123314) | `v0.84.2-95-gf5bd99245e` / `f5bd99245e40` |
| R2 | 2026-08-03 | Setup Scripts | 14.0s | 4.0s | 250% | [#334](https://github.com/githubnext/gh-aw-test/actions/runs/32547543586) | `v0.84.3-58-g53baccde53` / `53baccde5390` |
| R3 | 2026-08-17 | Upload usage artifact | 11.0s | 1.0s | 1000% | [#352](https://github.com/githubnext/gh-aw-test/actions/runs/32558234273) | `v0.87.0-133-g2b2cf3fb01` / `2b2cf3fb01ee` |
| R4 | 2026-08-19 | Set up job | 48.0s | 28.0s | 71% | [#354](https://github.com/githubnext/gh-aw-test/actions/runs/32559121042) | `v0.87.1-44-g5d5e0af5c4` / `5d5e0af5c46c` |

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
| R1 | 2026-07-23 to 2026-07-24 | Set up job | 29.0s | 3.5s | 729% | [#421](https://github.com/githubnext/gh-aw-test/actions/runs/32677647094) | `v0.83.2` / `56a38be41a18` |
| R2 | 2026-07-23 | Setup Scripts | 14.0s | 2.5s | 460% | [#420](https://github.com/githubnext/gh-aw-test/actions/runs/32677398942) | `v0.83.1` / `6268b9870d9f` |
| R3 | 2026-08-31 | Checkout .github and .agents folders | 17.0s | 2.0s | 750% | [#462](https://github.com/githubnext/gh-aw-test/actions/runs/33353384572) | `v0.87.10` / `ff62cdbec362` |
| R4 | 2026-08-31 | Set up job | 83.0s | 3.0s | 2667% | [#462](https://github.com/githubnext/gh-aw-test/actions/runs/33353384572) | `v0.87.10` / `ff62cdbec362` |
| R5 | 2026-08-31 | Setup Scripts | 16.0s | 3.0s | 433% | [#462](https://github.com/githubnext/gh-aw-test/actions/runs/33353384572) | `v0.87.10` / `ff62cdbec362` |

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

**67 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for main, using samples](timing-main-samples.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 67 | 190.0s | 242.0s |
| Workflow start to proxy step | 67 | 98.0s | 121.0s |
| Proxy step to first reasoning/sample | 67 | 0.0s | 0.4s |
| Job `activation` | 67 | 45.0s | 64.4s |
| Job `agent` | 67 | 44.0s | 56.4s |
| Job `detection` | 0 | n/a | n/a |
| Job `safe_outputs` | 67 | 31.0s | 42.4s |
| Job `conclusion` | 67 | 35.0s | 56.4s |
| Major step `Download container images` | 67 | 9.0s | 12.4s |
| Major step `Set up job` | 67 | 7.0s | 12.0s |
| Major step `Start MCP Gateway` | 67 | 6.0s | 11.0s |
| Major step `Install GitHub Copilot CLI` | 67 | 4.0s | 5.8s |
| Major step `Setup Scripts` | 66 | 2.0s | 4.0s |
| Major step `Checkout repository` | 10 | 2.0s | 2.0s |
| Major step `Install AWF binary` | 3 | 2.0s | 2.0s |
| Major step `Download activation artifact` | 21 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 12 | 2.0s | 2.0s |
| Major step `Stop MCP Gateway` | 7 | 2.0s | 2.0s |
| Major step `Upload agent output fallback artifact` | 1 | 2.0s | 2.0s |

### Major step times for job `activation` (`main`, using samples)

![Major step times for activation, main, using samples](steps-activation-main-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-07-27 | Set up job | 46.0s | 28.0s | 64% | [#266](https://github.com/githubnext/gh-aw-test/actions/runs/30271118206) | `55b5181bb8` / `55b5181bb855` |
| R2 | 2026-09-01 | Set up job | 71.0s | 32.0s | 122% | [#467](https://github.com/githubnext/gh-aw-test/actions/runs/33466354665) | `4a88fd99c3` / `4a88fd99c35f` |

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
| R1 | 2026-07-29 to 2026-08-02 | Set up job | 37.0s | 20.5s | 80% | [#279](https://github.com/githubnext/gh-aw-test/actions/runs/30683496745) | `a9137e1445` / `a9137e144504` |
| R2 | 2026-08-24 | Set up job | 54.0s | 27.5s | 96% | [#438](https://github.com/githubnext/gh-aw-test/actions/runs/32686992371) | `5f0cc8dcc8` / `5f0cc8dcc819` |

### Major step times for job `conclusion` (`main`, using samples)

![Major step times for conclusion, main, using samples](steps-conclusion-main-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-07-27 to 2026-07-29 | Set up job | 49.0s | 17.0s | 188% | [#270](https://github.com/githubnext/gh-aw-test/actions/runs/30421452781) | `acc797bbab` / `acc797bbab36` |
| R2 | 2026-08-28 | Setup Scripts | 15.0s | 3.0s | 400% | [#454](https://github.com/githubnext/gh-aw-test/actions/runs/33146418391) | `76f6ea7c22` / `76f6ea7c2220` |

## Run, job & step times (`released`, using samples)

**108 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for released, using samples](timing-released-samples.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 108 | 117.5s | 161.3s |
| Workflow start to proxy step | 108 | 63.0s | 96.3s |
| Proxy step to first reasoning/sample | 108 | 0.0s | 1.0s |
| Job `activation` | 108 | 17.0s | 37.5s |
| Job `agent` | 108 | 41.0s | 57.3s |
| Job `detection` | 0 | n/a | n/a |
| Job `safe_outputs` | 108 | 12.0s | 20.3s |
| Job `conclusion` | 108 | 16.0s | 22.0s |
| Major step `Download container images` | 108 | 9.0s | 17.0s |
| Major step `Install ripgrep` | 8 | 9.0s | 18.0s |
| Major step `Start MCP Gateway` | 108 | 7.0s | 12.0s |
| Major step `Install GitHub Copilot CLI` | 108 | 4.0s | 10.0s |
| Major step `Set up job` | 90 | 2.5s | 5.1s |
| Major step `Setup Scripts` | 97 | 2.0s | 4.0s |
| Major step `Install AWF binary` | 9 | 2.0s | 2.2s |
| Major step `Download activation artifact` | 34 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 22 | 2.0s | 2.0s |
| Major step `Stop MCP Gateway` | 13 | 2.0s | 2.0s |
| Major step `Checkout repository` | 7 | 2.0s | 2.0s |

### Major step times for job `activation` (`released`, using samples)

![Major step times for activation, released, using samples](steps-activation-released-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-07-23 to 2026-07-27 | Set up job | 21.0s | 3.0s | 600% | [#264](https://github.com/githubnext/gh-aw-test/actions/runs/30253250421) | `v0.83.4` / `bbb804287845` |
| R2 | 2026-07-25 | Setup Scripts | 18.0s | 2.5s | 620% | [#268](https://github.com/githubnext/gh-aw-test/actions/runs/30329600083) | `v0.83.3` / `7e728ffd6fc9` |
| R3 | 2026-08-25 | Setup Scripts | 14.0s | 2.5s | 460% | [#452](https://github.com/githubnext/gh-aw-test/actions/runs/33044810016) | `v0.87.5` / `654cf351a595` |
| R4 | 2026-08-31 | Set up job | 58.0s | 3.0s | 1833% | [#463](https://github.com/githubnext/gh-aw-test/actions/runs/33354115383) | `v0.87.10` / `ff62cdbec362` |
| R5 | 2026-08-31 | Setup Scripts | 21.0s | 2.0s | 950% | [#463](https://github.com/githubnext/gh-aw-test/actions/runs/33354115383) | `v0.87.10` / `ff62cdbec362` |

### Major step times for job `agent` (`released`, using samples)

![Major step times for agent, released, using samples](steps-agent-released-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-07-24 to 2026-07-25 | Download container images | 24.0s | 8.0s | 200% | [#263](https://github.com/githubnext/gh-aw-test/actions/runs/30238750701) | `v0.83.3` / `7e728ffd6fc9` |
| R2 | 2026-07-27 | Set up job | 28.0s | 3.0s | 833% | [#269](https://github.com/githubnext/gh-aw-test/actions/runs/30330754586) | `v0.83.4` / `bbb804287845` |
| R3 | 2026-08-11 | Download container images | 27.0s | 12.0s | 125% | [#398](https://github.com/githubnext/gh-aw-test/actions/runs/32617180095) | `v0.86.2` / `48e5fa3ff522` |
| R4 | 2026-08-11 | Install GitHub Copilot CLI | 15.0s | 4.0s | 275% | [#398](https://github.com/githubnext/gh-aw-test/actions/runs/32617180095) | `v0.86.2` / `48e5fa3ff522` |
| R5 | 2026-08-22 | Install GitHub Copilot CLI | 20.0s | 9.0s | 122% | [#399](https://github.com/githubnext/gh-aw-test/actions/runs/32618677146) | `v0.87.4` / `83d6315352f7` |
| R6 | 2026-08-31 | Download container images | 20.0s | 9.0s | 122% | [#465](https://github.com/githubnext/gh-aw-test/actions/runs/33357286535) | `v0.87.10` / `ff62cdbec362` |
| R7 | 2026-08-31 | Install GitHub Copilot CLI | 28.0s | 9.5s | 195% | [#468](https://github.com/githubnext/gh-aw-test/actions/runs/33468386886) | `v0.87.10` / `ff62cdbec362` |
| R8 | 2026-08-31 | Set up job | 13.0s | 2.0s | 550% | [#463](https://github.com/githubnext/gh-aw-test/actions/runs/33354115383) | `v0.87.10` / `ff62cdbec362` |

### Major step times for job `detection` (`released`, using samples)

![Major step times for detection, released, using samples](steps-detection-released-samples.svg)

#### Candidate regressions (last six weeks)

No candidate regressions in the last six weeks.

### Major step times for job `safe_outputs` (`released`, using samples)

![Major step times for safe_outputs, released, using samples](steps-safe-outputs-released-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-07-23 | Set up job | 14.0s | 2.5s | 460% | [#251](https://github.com/githubnext/gh-aw-test/actions/runs/30006117618) | `v0.83.1` / `6268b9870d9f` |
| R2 | 2026-07-25 | Setup Scripts | 20.0s | 2.0s | 900% | [#268](https://github.com/githubnext/gh-aw-test/actions/runs/30329600083) | `v0.83.3` / `7e728ffd6fc9` |
| R3 | 2026-07-27 | Set up job | 29.0s | 3.0s | 867% | [#264](https://github.com/githubnext/gh-aw-test/actions/runs/30253250421) | `v0.83.4` / `bbb804287845` |
| R4 | 2026-08-31 | Set up job | 14.0s | 2.0s | 600% | [#463](https://github.com/githubnext/gh-aw-test/actions/runs/33354115383) | `v0.87.10` / `ff62cdbec362` |

### Major step times for job `conclusion` (`released`, using samples)

![Major step times for conclusion, released, using samples](steps-conclusion-released-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-07-23 | Set up job | 23.0s | 3.0s | 667% | [#251](https://github.com/githubnext/gh-aw-test/actions/runs/30006117618) | `v0.83.1` / `6268b9870d9f` |
| R2 | 2026-07-27 | Set up job | 16.0s | 2.5s | 540% | [#264](https://github.com/githubnext/gh-aw-test/actions/runs/30253250421) | `v0.83.4` / `bbb804287845` |
| R3 | 2026-08-31 | Set up job | 67.0s | 2.0s | 3250% | [#463](https://github.com/githubnext/gh-aw-test/actions/runs/33354115383) | `v0.87.10` / `ff62cdbec362` |

## Method

Each section fixes both independent dimensions: gh-aw source (`main` or combined stable/pre-release `released`) and execution mode (`inference` or `samples`). Only overall-successful `workflow_dispatch` runs with a successful `agent` job are included. Candidate regression baselines use up to ten preceding observations from the same section and step; displayed regression episodes are limited to the six weeks before report generation. A step is graphed when it has a sustained cost, recent slowdown, or recent regression. Runs with missing compiler metadata remain in CSV/JSON but are excluded from graphs.

For inference runs, `Execute GitHub Copilot CLI` is additionally split using timestamped runtime markers: **AWF startup** is step start to the AWF agent-container entrypoint, **harness startup** is that entrypoint to the first Copilot process start, and **Copilot process** is the first process start through the final process close (including retries and retry delays). Cleanup after process close remains visible only in the full step duration, while unavailable markers produce no phase value.
