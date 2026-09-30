# Performance history for `copilot-create-issue.md`

## Run, job & step times (`main`, using inference)

**95 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for main, using inference](timing-main-inference.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 95 | 337.0s | 435.8s |
| Workflow start to proxy step | 95 | 113.0s | 140.0s |
| Proxy step to first reasoning/sample | 87 | 20.9s | 26.9s |
| Copilot phase — AWF startup | 87 | 14.3s | 19.4s |
| Copilot phase — harness startup | 87 | 2.1s | 4.8s |
| Copilot phase — Copilot process | 87 | 6.7s | 9.5s |
| Job `activation` | 95 | 48.0s | 68.0s |
| Job `agent` | 95 | 89.0s | 168.6s |
| Job `detection` | 95 | 74.0s | 97.0s |
| Job `safe_outputs` | 95 | 39.0s | 68.2s |
| Job `conclusion` | 95 | 44.0s | 59.2s |
| Major step `Execute GitHub Copilot CLI` | 95 | 28.0s | 113.0s |
| Major step `Set up job` | 95 | 17.0s | 21.6s |
| Major step `Install ripgrep` | 6 | 14.0s | 19.0s |
| Major step `Download container images` | 95 | 11.0s | 18.6s |
| Major step `Start MCP Gateway` | 95 | 6.0s | 11.0s |
| Major step `Install GitHub Copilot CLI` | 95 | 5.0s | 13.0s |
| Major step `Setup Scripts` | 94 | 3.0s | 5.0s |
| Major step `Download activation artifact` | 44 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 28 | 2.0s | 2.0s |
| Major step `Checkout repository` | 20 | 2.0s | 2.0s |
| Major step `Install AWF binary` | 6 | 2.0s | 2.0s |
| Major step `Stop MCP Gateway` | 10 | 2.0s | 2.0s |
| Major step `Print firewall logs` | 2 | 2.0s | 2.0s |
| Major step `Audit pre-agent workspace` | 1 | 2.0s | 2.0s |
| Major step `Upload agent output fallback artifact` | 4 | 2.0s | 2.0s |

### Major step times for job `activation` (`main`, using inference)

![Major step times for activation, main, using inference](steps-activation-main-inference.svg)

#### Candidate regressions (last six weeks)

No candidate regressions in the last six weeks.

### Major step times for job `agent` (`main`, using inference)

![Major step times for agent, main, using inference](steps-agent-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-02 | Copilot phase — AWF startup | 27.9s | 15.2s | 84% | [#470](https://github.com/githubnext/gh-aw-test/actions/runs/33586531796) | `bde2c79aa0` / `bde2c79aa0d6` |
| R2 | 2026-09-02 | Download container images | 24.0s | 9.0s | 167% | [#470](https://github.com/githubnext/gh-aw-test/actions/runs/33586531796) | `bde2c79aa0` / `bde2c79aa0d6` |
| R3 | 2026-09-02 | Execute GitHub Copilot CLI | 47.0s | 24.0s | 96% | [#470](https://github.com/githubnext/gh-aw-test/actions/runs/33586531796) | `bde2c79aa0` / `bde2c79aa0d6` |
| R4 | 2026-09-05 | Install GitHub Copilot CLI | 20.0s | 8.0s | 150% | [#481](https://github.com/githubnext/gh-aw-test/actions/runs/33941353410) | `5473143ca3` / `5473143ca3ae` |
| R5 | 2026-09-24 | Download container images | 22.0s | 10.5s | 110% | [#560](https://github.com/githubnext/gh-aw-test/actions/runs/35950771050) | `a3f8c9f673` / `a3f8c9f67357` |
| R6 | 2026-09-24 | Start MCP Gateway | 18.0s | 8.0s | 125% | [#560](https://github.com/githubnext/gh-aw-test/actions/runs/35950771050) | `a3f8c9f673` / `a3f8c9f67357` |

### Major step times for job `detection` (`main`, using inference)

![Major step times for detection, main, using inference](steps-detection-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-24 | Download container images | 12.0s | 1.0s | 1100% | [#437](https://github.com/githubnext/gh-aw-test/actions/runs/32686470697) | `5f0cc8dcc8` / `5f0cc8dcc819` |

### Major step times for job `safe_outputs` (`main`, using inference)

![Major step times for safe_outputs, main, using inference](steps-safe-outputs-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-25 | Download agent output artifact | 12.0s | 1.0s | 1100% | [#445](https://github.com/githubnext/gh-aw-test/actions/runs/32926588860) | `818e3a3863` / `818e3a386376` |
| R2 | 2026-09-07 | Set up job | 70.0s | 35.0s | 100% | [#486](https://github.com/githubnext/gh-aw-test/actions/runs/34079107256) | `e79e3685c1` / `e79e3685c126` |
| R3 | 2026-09-11 | Set up job | 70.0s | 32.0s | 119% | [#502](https://github.com/githubnext/gh-aw-test/actions/runs/34557783678) | `1787de5150` / `1787de5150ac` |

### Major step times for job `conclusion` (`main`, using inference)

![Major step times for conclusion, main, using inference](steps-conclusion-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-19 | Set up job | 48.0s | 28.0s | 71% | [#354](https://github.com/githubnext/gh-aw-test/actions/runs/32559121042) | `v0.87.1-44-g5d5e0af5c4` / `5d5e0af5c46c` |

## Run, job & step times (`released`, using inference)

**68 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for released, using inference](timing-released-inference.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 68 | 226.5s | 353.0s |
| Workflow start to proxy step | 68 | 63.0s | 90.0s |
| Proxy step to first reasoning/sample | 68 | 21.4s | 29.1s |
| Copilot phase — AWF startup | 68 | 13.5s | 18.7s |
| Copilot phase — harness startup | 68 | 1.9s | 5.3s |
| Copilot phase — Copilot process | 68 | 7.8s | 8.8s |
| Job `activation` | 68 | 17.0s | 40.0s |
| Job `agent` | 68 | 77.0s | 158.0s |
| Job `detection` | 68 | 54.0s | 86.0s |
| Job `safe_outputs` | 68 | 12.0s | 23.0s |
| Job `conclusion` | 68 | 15.5s | 22.0s |
| Major step `Execute GitHub Copilot CLI` | 68 | 30.0s | 116.0s |
| Major step `Download container images` | 68 | 12.0s | 18.0s |
| Major step `Install ripgrep` | 6 | 12.0s | 15.0s |
| Major step `Start MCP Gateway` | 68 | 6.0s | 10.0s |
| Major step `Install GitHub Copilot CLI` | 68 | 4.0s | 10.0s |
| Major step `Set up job` | 64 | 3.0s | 4.0s |
| Major step `Setup Scripts` | 66 | 3.0s | 4.0s |
| Major step `Stop MCP Gateway` | 12 | 2.0s | 2.0s |
| Major step `Install AWF binary` | 6 | 2.0s | 2.0s |
| Major step `Download activation artifact` | 20 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 14 | 2.0s | 2.0s |
| Major step `Checkout repository` | 20 | 2.0s | 2.1s |

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
| R1 | 2026-08-31 | Copilot phase — AWF startup | 35.6s | 16.0s | 122% | [#462](https://github.com/githubnext/gh-aw-test/actions/runs/33353384572) | `v0.87.10` / `ff62cdbec362` |
| R2 | 2026-08-31 | Download container images | 46.0s | 8.0s | 475% | [#462](https://github.com/githubnext/gh-aw-test/actions/runs/33353384572) | `v0.87.10` / `ff62cdbec362` |
| R3 | 2026-08-31 | Execute GitHub Copilot CLI | 62.0s | 28.0s | 121% | [#462](https://github.com/githubnext/gh-aw-test/actions/runs/33353384572) | `v0.87.10` / `ff62cdbec362` |
| R4 | 2026-08-31 | Set up job | 29.0s | 3.0s | 867% | [#462](https://github.com/githubnext/gh-aw-test/actions/runs/33353384572) | `v0.87.10` / `ff62cdbec362` |
| R5 | 2026-08-31 | Start MCP Gateway | 23.0s | 7.0s | 229% | [#462](https://github.com/githubnext/gh-aw-test/actions/runs/33353384572) | `v0.87.10` / `ff62cdbec362` |

### Major step times for job `detection` (`released`, using inference)

![Major step times for detection, released, using inference](steps-detection-released-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-22 | Download container images | 11.0s | 1.0s | 1000% | [#436](https://github.com/githubnext/gh-aw-test/actions/runs/32681695209) | `v0.87.4` / `83d6315352f7` |
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
| R1 | 2026-08-31 | Set up job | 27.0s | 2.0s | 1250% | [#462](https://github.com/githubnext/gh-aw-test/actions/runs/33353384572) | `v0.87.10` / `ff62cdbec362` |

## Run, job & step times (`main`, using samples)

**84 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for main, using samples](timing-main-samples.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 84 | 198.0s | 257.0s |
| Workflow start to proxy step | 84 | 99.0s | 132.7s |
| Proxy step to first reasoning/sample | 84 | 0.0s | 0.0s |
| Job `activation` | 84 | 46.0s | 71.2s |
| Job `agent` | 84 | 47.0s | 59.7s |
| Job `detection` | 0 | n/a | n/a |
| Job `safe_outputs` | 84 | 32.0s | 53.4s |
| Job `conclusion` | 84 | 36.5s | 60.0s |
| Major step `Download container images` | 84 | 9.0s | 13.0s |
| Major step `Set up job` | 84 | 8.5s | 12.0s |
| Major step `Start MCP Gateway` | 84 | 6.0s | 11.0s |
| Major step `Install GitHub Copilot CLI` | 84 | 4.0s | 11.0s |
| Major step `Setup Scripts` | 83 | 3.0s | 5.0s |
| Major step `Checkout repository` | 15 | 2.0s | 2.0s |
| Major step `Install AWF binary` | 3 | 2.0s | 2.0s |
| Major step `Download activation artifact` | 29 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 18 | 2.0s | 2.0s |
| Major step `Stop MCP Gateway` | 9 | 2.0s | 2.0s |
| Major step `Upload agent output fallback artifact` | 2 | 2.0s | 2.0s |

### Major step times for job `activation` (`main`, using samples)

![Major step times for activation, main, using samples](steps-activation-main-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-30 to 2026-09-01 | Set up job | 71.0s | 32.0s | 122% | [#467](https://github.com/githubnext/gh-aw-test/actions/runs/33466354665) | `4a88fd99c3` / `4a88fd99c35f` |
| R2 | 2026-09-05 | Set up job | 73.0s | 32.0s | 128% | [#482](https://github.com/githubnext/gh-aw-test/actions/runs/33941860161) | `5473143ca3` / `5473143ca3ae` |
| R3 | 2026-09-10 | Setup Scripts | 15.0s | 5.0s | 200% | [#499](https://github.com/githubnext/gh-aw-test/actions/runs/34433325600) | `099efdda60` / `099efdda60fe` |

### Major step times for job `agent` (`main`, using samples)

![Major step times for agent, main, using samples](steps-agent-main-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-24 | Download container images | 22.0s | 9.5s | 132% | [#561](https://github.com/githubnext/gh-aw-test/actions/runs/35951540488) | `a3f8c9f673` / `a3f8c9f67357` |
| R2 | 2026-09-24 | Start MCP Gateway | 17.0s | 6.5s | 162% | [#561](https://github.com/githubnext/gh-aw-test/actions/runs/35951540488) | `a3f8c9f673` / `a3f8c9f67357` |
| R3 | 2026-09-25 | Set up job | 23.0s | 11.0s | 109% | [#565](https://github.com/githubnext/gh-aw-test/actions/runs/36090369897) | `8dcc371713` / `8dcc371713b1` |

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
| R2 | 2026-09-04 to 2026-09-10 | Set up job | 87.0s | 39.0s | 123% | [#499](https://github.com/githubnext/gh-aw-test/actions/runs/34433325600) | `099efdda60` / `099efdda60fe` |
| R3 | 2026-09-10 | Setup Scripts | 16.0s | 6.0s | 167% | [#499](https://github.com/githubnext/gh-aw-test/actions/runs/34433325600) | `099efdda60` / `099efdda60fe` |

### Major step times for job `conclusion` (`main`, using samples)

![Major step times for conclusion, main, using samples](steps-conclusion-main-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-27 to 2026-08-28 | Set up job | 37.0s | 23.0s | 61% | [#450](https://github.com/githubnext/gh-aw-test/actions/runs/33041351054) | `55e950d179` / `55e950d17953` |
| R2 | 2026-08-28 | Setup Scripts | 15.0s | 4.0s | 275% | [#454](https://github.com/githubnext/gh-aw-test/actions/runs/33146418391) | `76f6ea7c22` / `76f6ea7c2220` |
| R3 | 2026-09-25 | Set up job | 54.0s | 27.0s | 100% | [#565](https://github.com/githubnext/gh-aw-test/actions/runs/36090369897) | `8dcc371713` / `8dcc371713b1` |

## Run, job & step times (`released`, using samples)

**148 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for released, using samples](timing-released-samples.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 148 | 123.0s | 162.6s |
| Workflow start to proxy step | 148 | 68.0s | 96.3s |
| Proxy step to first reasoning/sample | 148 | 0.0s | 1.0s |
| Job `activation` | 148 | 18.0s | 33.2s |
| Job `agent` | 148 | 43.0s | 60.3s |
| Job `detection` | 0 | n/a | n/a |
| Job `safe_outputs` | 148 | 13.0s | 22.0s |
| Job `conclusion` | 148 | 16.0s | 23.0s |
| Major step `Download container images` | 148 | 9.0s | 17.0s |
| Major step `Install ripgrep` | 15 | 9.0s | 15.0s |
| Major step `Start MCP Gateway` | 148 | 7.0s | 11.0s |
| Major step `Install GitHub Copilot CLI` | 148 | 4.0s | 12.6s |
| Major step `Set up job` | 122 | 3.0s | 5.9s |
| Major step `Setup Scripts` | 136 | 2.0s | 4.0s |
| Major step `Install AWF binary` | 13 | 2.0s | 2.0s |
| Major step `Download activation artifact` | 47 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 26 | 2.0s | 2.0s |
| Major step `Stop MCP Gateway` | 18 | 2.0s | 2.0s |
| Major step `Checkout repository` | 15 | 2.0s | 2.6s |
| Major step `Upload agent output fallback artifact` | 2 | 2.0s | 2.0s |

### Major step times for job `activation` (`released`, using samples)

![Major step times for activation, released, using samples](steps-activation-released-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-25 | Setup Scripts | 14.0s | 2.0s | 600% | [#452](https://github.com/githubnext/gh-aw-test/actions/runs/33044810016) | `v0.87.5` / `654cf351a595` |
| R2 | 2026-08-31 | Set up job | 58.0s | 3.0s | 1833% | [#463](https://github.com/githubnext/gh-aw-test/actions/runs/33354115383) | `v0.87.10` / `ff62cdbec362` |
| R3 | 2026-08-31 | Setup Scripts | 21.0s | 2.0s | 950% | [#463](https://github.com/githubnext/gh-aw-test/actions/runs/33354115383) | `v0.87.10` / `ff62cdbec362` |
| R4 | 2026-09-03 | Set up job | 14.0s | 3.0s | 367% | [#475](https://github.com/githubnext/gh-aw-test/actions/runs/33716003352) | `v0.88.2` / `8e30bcd8897f` |
| R5 | 2026-09-08 | Checkout .github and .agents folders | 18.0s | 2.0s | 800% | [#500](https://github.com/githubnext/gh-aw-test/actions/runs/34435478909) | `v0.88.7` / `bde367913ade` |

### Major step times for job `agent` (`released`, using samples)

![Major step times for agent, released, using samples](steps-agent-released-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-22 | Install GitHub Copilot CLI | 20.0s | 9.0s | 122% | [#444](https://github.com/githubnext/gh-aw-test/actions/runs/32809352756) | `v0.87.4` / `83d6315352f7` |
| R2 | 2026-08-31 | Download container images | 20.0s | 9.0s | 122% | [#465](https://github.com/githubnext/gh-aw-test/actions/runs/33357286535) | `v0.87.10` / `ff62cdbec362` |
| R3 | 2026-08-31 | Install GitHub Copilot CLI | 28.0s | 9.0s | 211% | [#468](https://github.com/githubnext/gh-aw-test/actions/runs/33468386886) | `v0.87.10` / `ff62cdbec362` |
| R4 | 2026-08-31 | Set up job | 13.0s | 3.0s | 333% | [#463](https://github.com/githubnext/gh-aw-test/actions/runs/33354115383) | `v0.87.10` / `ff62cdbec362` |
| R5 | 2026-09-04 | Install GitHub Copilot CLI | 29.0s | 8.0s | 262% | [#489](https://github.com/githubnext/gh-aw-test/actions/runs/34083680068) | `v0.88.4` / `82239c030d6a` |
| R6 | 2026-09-23 | Download container images | 19.0s | 9.0s | 111% | [#562](https://github.com/githubnext/gh-aw-test/actions/runs/35955952570) | `v0.89.20` / `606cfab7f7f2` |

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
| R2 | 2026-09-03 | Set up job | 18.0s | 3.0s | 500% | [#475](https://github.com/githubnext/gh-aw-test/actions/runs/33716003352) | `v0.88.2` / `8e30bcd8897f` |
| R3 | 2026-09-07 to 2026-09-08 | Set up job | 18.0s | 6.5s | 177% | [#493](https://github.com/githubnext/gh-aw-test/actions/runs/34187353416) | `v0.88.6` / `b52dd75307b4` |

### Major step times for job `conclusion` (`released`, using samples)

![Major step times for conclusion, released, using samples](steps-conclusion-released-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-31 | Set up job | 67.0s | 2.0s | 3250% | [#463](https://github.com/githubnext/gh-aw-test/actions/runs/33354115383) | `v0.87.10` / `ff62cdbec362` |
| R2 | 2026-09-03 | Set up job | 34.0s | 2.0s | 1600% | [#475](https://github.com/githubnext/gh-aw-test/actions/runs/33716003352) | `v0.88.2` / `8e30bcd8897f` |

## Method

Each section fixes both independent dimensions: gh-aw source (`main` or combined stable/pre-release `released`) and execution mode (`inference` or `samples`). Only overall-successful `workflow_dispatch` runs with a successful `agent` job are included. Candidate regression baselines use up to ten preceding observations from the same section and step; displayed regression episodes are limited to the six weeks before report generation. A step is graphed when it has a sustained cost, recent slowdown, or recent regression. Runs with missing compiler metadata remain in CSV/JSON but are excluded from graphs.

For inference runs, `Execute GitHub Copilot CLI` is additionally split using timestamped runtime markers: **AWF startup** is step start to the AWF agent-container entrypoint, **harness startup** is that entrypoint to the first Copilot process start, and **Copilot process** is the first process start through the final process close (including retries and retry delays). Cleanup after process close remains visible only in the full step duration, while unavailable markers produce no phase value.
