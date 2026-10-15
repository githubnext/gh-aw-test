# Performance history for `copilot-create-issue.md`

## Run, job & step times (`main`, using inference)

**117 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for main, using inference](timing-main-inference.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 117 | 346.0s | 434.2s |
| Workflow start to proxy step | 117 | 114.0s | 148.4s |
| Proxy step to first reasoning/sample | 109 | 20.9s | 28.5s |
| Copilot phase — AWF startup | 109 | 14.2s | 19.7s |
| Copilot phase — harness startup | 109 | 1.9s | 4.6s |
| Copilot phase — Copilot process | 109 | 6.5s | 9.4s |
| Job `activation` | 117 | 48.0s | 72.8s |
| Job `agent` | 117 | 89.0s | 168.0s |
| Job `detection` | 117 | 75.0s | 97.0s |
| Job `safe_outputs` | 117 | 41.0s | 67.0s |
| Job `conclusion` | 117 | 45.0s | 65.0s |
| Major step `Execute GitHub Copilot CLI` | 117 | 27.0s | 113.0s |
| Major step `Set up job` | 117 | 18.0s | 23.0s |
| Major step `Install ripgrep` | 6 | 14.0s | 19.0s |
| Major step `Download container images` | 117 | 11.0s | 18.0s |
| Major step `Start MCP Gateway` | 117 | 6.0s | 11.0s |
| Major step `Install GitHub Copilot CLI` | 117 | 4.0s | 11.4s |
| Major step `Setup Scripts` | 116 | 3.0s | 5.0s |
| Major step `Download activation artifact` | 50 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 32 | 2.0s | 2.0s |
| Major step `Checkout repository` | 27 | 2.0s | 3.0s |
| Major step `Install AWF binary` | 9 | 2.0s | 2.0s |
| Major step `Stop MCP Gateway` | 14 | 2.0s | 2.0s |
| Major step `Print firewall logs` | 2 | 2.0s | 2.0s |
| Major step `Audit pre-agent workspace` | 1 | 2.0s | 2.0s |
| Major step `Upload agent output fallback artifact` | 4 | 2.0s | 2.0s |
| Major step `Checkout repository (gh-aw default)` | 1 | 2.0s | 2.0s |

### Major step times for job `activation` (`main`, using inference)

![Major step times for activation, main, using inference](steps-activation-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-12 to 2026-09-16 | Set up job | 72.0s | 36.0s | 100% | [#517](https://github.com/githubnext/gh-aw-test/actions/runs/34811072379) | `aa0cabfb25` / `aa0cabfb259e` |

### Major step times for job `agent` (`main`, using inference)

![Major step times for agent, main, using inference](steps-agent-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-05 | Install GitHub Copilot CLI | 20.0s | 9.0s | 122% | [#481](https://github.com/githubnext/gh-aw-test/actions/runs/33941353410) | `5473143ca3` / `5473143ca3ae` |
| R2 | 2026-09-24 | Download container images | 22.0s | 10.5s | 110% | [#560](https://github.com/githubnext/gh-aw-test/actions/runs/35950771050) | `a3f8c9f673` / `a3f8c9f67357` |
| R3 | 2026-09-24 | Execute GitHub Copilot CLI | 35.0s | 22.5s | 56% | [#560](https://github.com/githubnext/gh-aw-test/actions/runs/35950771050) | `a3f8c9f673` / `a3f8c9f67357` |
| R4 | 2026-09-24 | Start MCP Gateway | 18.0s | 5.5s | 227% | [#560](https://github.com/githubnext/gh-aw-test/actions/runs/35950771050) | `a3f8c9f673` / `a3f8c9f67357` |
| R5 | 2026-09-27 | Install GitHub Copilot CLI | 29.0s | 4.0s | 625% | [#572](https://github.com/githubnext/gh-aw-test/actions/runs/36290978751) | `ba0499c5a4` / `ba0499c5a462` |
| R6 | 2026-09-27 | Start MCP Gateway | 17.0s | 5.5s | 209% | [#576](https://github.com/githubnext/gh-aw-test/actions/runs/36373361100) | `60ff367876` / `60ff367876c6` |
| R7 | 2026-10-01 | Copilot phase — AWF startup | 31.9s | 14.1s | 125% | [#588](https://github.com/githubnext/gh-aw-test/actions/runs/36810119640) | `55f35d4bdf` / `55f35d4bdfbc` |
| R8 | 2026-10-01 | Download container images | 26.0s | 10.5s | 148% | [#588](https://github.com/githubnext/gh-aw-test/actions/runs/36810119640) | `55f35d4bdf` / `55f35d4bdfbc` |
| R9 | 2026-10-01 | Execute GitHub Copilot CLI | 47.0s | 24.5s | 92% | [#588](https://github.com/githubnext/gh-aw-test/actions/runs/36810119640) | `55f35d4bdf` / `55f35d4bdfbc` |

### Major step times for job `detection` (`main`, using inference)

![Major step times for detection, main, using inference](steps-detection-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-30 | Execute threat detection with AWF | 66.0s | 28.5s | 132% | [#584](https://github.com/githubnext/gh-aw-test/actions/runs/36663803035) | `03b8f74820` / `03b8f7482069` |
| R2 | 2026-09-30 | Install GitHub Copilot CLI | 24.0s | 6.0s | 300% | [#584](https://github.com/githubnext/gh-aw-test/actions/runs/36663803035) | `03b8f74820` / `03b8f7482069` |
| R3 | 2026-10-03 | Install GitHub Copilot CLI | 26.0s | 8.0s | 225% | [#596](https://github.com/githubnext/gh-aw-test/actions/runs/37093124717) | `fe02b64412` / `fe02b644122e` |
| R4 | 2026-10-11 | Install GitHub Copilot CLI | 22.0s | 10.0s | 120% | [#627](https://github.com/githubnext/gh-aw-test/actions/runs/38108164405) | `a1376acf2e` / `a1376acf2ead` |

### Major step times for job `safe_outputs` (`main`, using inference)

![Major step times for safe_outputs, main, using inference](steps-safe-outputs-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-07 | Set up job | 70.0s | 34.0s | 106% | [#486](https://github.com/githubnext/gh-aw-test/actions/runs/34079107256) | `e79e3685c1` / `e79e3685c126` |
| R2 | 2026-09-11 | Set up job | 70.0s | 35.5s | 97% | [#502](https://github.com/githubnext/gh-aw-test/actions/runs/34557783678) | `1787de5150` / `1787de5150ac` |
| R3 | 2026-09-14 to 2026-09-18 | Set up job | 79.0s | 32.5s | 143% | [#529](https://github.com/githubnext/gh-aw-test/actions/runs/35074766458) | `0fea86e118` / `0fea86e1185f` |
| R4 | 2026-10-09 | Set up job | 131.0s | 36.5s | 259% | [#619](https://github.com/githubnext/gh-aw-test/actions/runs/37878870672) | `c268866353` / `c2688663530a` |
| R5 | 2026-10-09 | Setup Scripts | 59.0s | 3.5s | 1586% | [#619](https://github.com/githubnext/gh-aw-test/actions/runs/37878870672) | `c268866353` / `c2688663530a` |
| R6 | 2026-10-15 | Set up job | 59.0s | 34.5s | 71% | [#649](https://github.com/githubnext/gh-aw-test/actions/runs/38685973796) | `5eb4c298ec` / `5eb4c298ecba` |

### Major step times for job `conclusion` (`main`, using inference)

![Major step times for conclusion, main, using inference](steps-conclusion-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-16 | Setup Scripts | 16.0s | 3.0s | 433% | [#529](https://github.com/githubnext/gh-aw-test/actions/runs/35074766458) | `0fea86e118` / `0fea86e1185f` |
| R2 | 2026-09-17 | Set up job | 112.0s | 40.0s | 180% | [#531](https://github.com/githubnext/gh-aw-test/actions/runs/35177511214) | `290730bc39` / `290730bc3932` |
| R3 | 2026-10-04 | Set up job | 49.0s | 32.0s | 53% | [#599](https://github.com/githubnext/gh-aw-test/actions/runs/37176542463) | `054871a707` / `054871a7076b` |
| R4 | 2026-10-15 | Set up job | 78.0s | 32.5s | 140% | [#645](https://github.com/githubnext/gh-aw-test/actions/runs/38675409397) | `e7bc6056a7` / `e7bc6056a784` |

## Run, job & step times (`released`, using inference)

**35 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for released, using inference](timing-released-inference.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 35 | 228.0s | 356.6s |
| Workflow start to proxy step | 35 | 63.0s | 90.0s |
| Proxy step to first reasoning/sample | 35 | 21.2s | 28.7s |
| Copilot phase — AWF startup | 35 | 13.7s | 18.5s |
| Copilot phase — harness startup | 35 | 2.0s | 4.8s |
| Copilot phase — Copilot process | 35 | 7.7s | 8.8s |
| Job `activation` | 35 | 17.0s | 46.6s |
| Job `agent` | 35 | 79.0s | 157.6s |
| Job `detection` | 35 | 54.0s | 82.4s |
| Job `safe_outputs` | 35 | 12.0s | 30.2s |
| Job `conclusion` | 35 | 16.0s | 23.8s |
| Major step `Execute GitHub Copilot CLI` | 35 | 30.0s | 115.6s |
| Major step `Download container images` | 35 | 12.0s | 17.6s |
| Major step `Install ripgrep` | 3 | 12.0s | 14.4s |
| Major step `Start MCP Gateway` | 35 | 6.0s | 9.6s |
| Major step `Install GitHub Copilot CLI` | 35 | 4.0s | 9.6s |
| Major step `Set up job` | 33 | 3.0s | 4.0s |
| Major step `Setup Scripts` | 34 | 3.0s | 4.0s |
| Major step `Stop MCP Gateway` | 6 | 2.0s | 2.0s |
| Major step `Install AWF binary` | 3 | 2.0s | 2.0s |
| Major step `Download activation artifact` | 10 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 7 | 2.0s | 2.0s |
| Major step `Checkout repository` | 11 | 2.0s | 2.0s |

### Major step times for job `activation` (`released`, using inference)

![Major step times for activation, released, using inference](steps-activation-released-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-22 | Set up job | 37.0s | 3.0s | 1133% | [#556](https://github.com/githubnext/gh-aw-test/actions/runs/35813644549) | `v0.89.19` / `5f477dc0d3df` |

### Major step times for job `agent` (`released`, using inference)

![Major step times for agent, released, using inference](steps-agent-released-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-22 | Set up job | 18.0s | 3.0s | 500% | [#556](https://github.com/githubnext/gh-aw-test/actions/runs/35813644549) | `v0.89.19` / `5f477dc0d3df` |

### Major step times for job `detection` (`released`, using inference)

![Major step times for detection, released, using inference](steps-detection-released-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-22 | Set up job | 23.0s | 2.0s | 1050% | [#556](https://github.com/githubnext/gh-aw-test/actions/runs/35813644549) | `v0.89.19` / `5f477dc0d3df` |

### Major step times for job `safe_outputs` (`released`, using inference)

![Major step times for safe_outputs, released, using inference](steps-safe-outputs-released-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-22 | Set up job | 45.0s | 3.0s | 1400% | [#556](https://github.com/githubnext/gh-aw-test/actions/runs/35813644549) | `v0.89.19` / `5f477dc0d3df` |

### Major step times for job `conclusion` (`released`, using inference)

![Major step times for conclusion, released, using inference](steps-conclusion-released-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-22 | Set up job | 23.0s | 3.0s | 667% | [#556](https://github.com/githubnext/gh-aw-test/actions/runs/35813644549) | `v0.89.19` / `5f477dc0d3df` |

## Run, job & step times (`main`, using samples)

**110 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for main, using samples](timing-main-samples.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 110 | 207.0s | 269.2s |
| Workflow start to proxy step | 110 | 101.5s | 132.1s |
| Proxy step to first reasoning/sample | 110 | 0.0s | 0.1s |
| Job `activation` | 110 | 46.0s | 73.0s |
| Job `agent` | 110 | 48.5s | 61.1s |
| Job `detection` | 0 | n/a | n/a |
| Job `safe_outputs` | 110 | 35.0s | 56.0s |
| Job `conclusion` | 110 | 39.0s | 65.1s |
| Major step `Download container images` | 110 | 10.0s | 14.0s |
| Major step `Set up job` | 110 | 9.0s | 14.0s |
| Major step `Start MCP Gateway` | 110 | 6.0s | 11.0s |
| Major step `Print firewall logs` | 1 | 5.0s | 5.0s |
| Major step `Install GitHub Copilot CLI` | 110 | 4.0s | 11.0s |
| Major step `Setup Scripts` | 109 | 3.0s | 5.0s |
| Major step `Checkout repository` | 26 | 2.0s | 3.0s |
| Major step `Install AWF binary` | 4 | 2.0s | 2.0s |
| Major step `Download activation artifact` | 37 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 20 | 2.0s | 2.0s |
| Major step `Stop MCP Gateway` | 17 | 2.0s | 2.0s |
| Major step `Upload agent output fallback artifact` | 5 | 2.0s | 2.0s |
| Major step `Checkout repository (gh-aw default)` | 4 | 2.0s | 2.0s |

### Major step times for job `activation` (`main`, using samples)

![Major step times for activation, main, using samples](steps-activation-main-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-05 | Set up job | 73.0s | 33.0s | 121% | [#482](https://github.com/githubnext/gh-aw-test/actions/runs/33941860161) | `5473143ca3` / `5473143ca3ae` |
| R2 | 2026-09-10 | Setup Scripts | 15.0s | 4.5s | 233% | [#499](https://github.com/githubnext/gh-aw-test/actions/runs/34433325600) | `099efdda60` / `099efdda60fe` |
| R3 | 2026-09-14 to 2026-09-18 | Set up job | 111.0s | 34.5s | 222% | [#526](https://github.com/githubnext/gh-aw-test/actions/runs/35051876292) | `ac594b6525` / `ac594b6525e3` |
| R4 | 2026-09-15 | Checkout .github and .agents folders | 13.0s | 2.0s | 550% | [#526](https://github.com/githubnext/gh-aw-test/actions/runs/35051876292) | `ac594b6525` / `ac594b6525e3` |
| R5 | 2026-09-30 | Set up job | 43.0s | 25.5s | 69% | [#585](https://github.com/githubnext/gh-aw-test/actions/runs/36664634145) | `03b8f74820` / `03b8f7482069` |
| R6 | 2026-10-10 | Setup Scripts | 24.0s | 4.5s | 433% | [#624](https://github.com/githubnext/gh-aw-test/actions/runs/38020774086) | `6976a375a2` / `6976a375a288` |
| R7 | 2026-10-11 | Set up job | 86.0s | 32.0s | 169% | [#628](https://github.com/githubnext/gh-aw-test/actions/runs/38108788934) | `a1376acf2e` / `a1376acf2ead` |

### Major step times for job `agent` (`main`, using samples)

![Major step times for agent, main, using samples](steps-agent-main-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-24 | Download container images | 22.0s | 10.5s | 110% | [#561](https://github.com/githubnext/gh-aw-test/actions/runs/35951540488) | `a3f8c9f673` / `a3f8c9f67357` |
| R2 | 2026-09-24 | Start MCP Gateway | 17.0s | 5.5s | 209% | [#561](https://github.com/githubnext/gh-aw-test/actions/runs/35951540488) | `a3f8c9f673` / `a3f8c9f67357` |
| R3 | 2026-09-25 | Set up job | 23.0s | 8.0s | 188% | [#565](https://github.com/githubnext/gh-aw-test/actions/runs/36090369897) | `8dcc371713` / `8dcc371713b1` |
| R4 | 2026-09-27 | Install GitHub Copilot CLI | 14.0s | 4.0s | 250% | [#577](https://github.com/githubnext/gh-aw-test/actions/runs/36374032160) | `60ff367876` / `60ff367876c6` |
| R5 | 2026-10-08 | Set up job | 20.0s | 10.0s | 100% | [#616](https://github.com/githubnext/gh-aw-test/actions/runs/37723139085) | `23403d903f` / `23403d903f5c` |

### Major step times for job `detection` (`main`, using samples)

![Major step times for detection, main, using samples](steps-detection-main-samples.svg)

#### Candidate regressions (last six weeks)

No candidate regressions in the last six weeks.

### Major step times for job `safe_outputs` (`main`, using samples)

![Major step times for safe_outputs, main, using samples](steps-safe-outputs-main-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-04 to 2026-09-10 | Set up job | 98.0s | 24.5s | 300% | [#491](https://github.com/githubnext/gh-aw-test/actions/runs/34183526364) | `4fbd3efbb3` / `4fbd3efbb3c2` |
| R2 | 2026-09-10 | Setup Scripts | 16.0s | 6.0s | 167% | [#499](https://github.com/githubnext/gh-aw-test/actions/runs/34433325600) | `099efdda60` / `099efdda60fe` |
| R3 | 2026-09-15 | Set up job | 87.0s | 38.0s | 129% | [#526](https://github.com/githubnext/gh-aw-test/actions/runs/35051876292) | `ac594b6525` / `ac594b6525e3` |
| R4 | 2026-09-27 | Set up job | 99.0s | 29.5s | 236% | [#577](https://github.com/githubnext/gh-aw-test/actions/runs/36374032160) | `60ff367876` / `60ff367876c6` |
| R5 | 2026-09-27 | Setup Scripts | 18.0s | 4.0s | 350% | [#577](https://github.com/githubnext/gh-aw-test/actions/runs/36374032160) | `60ff367876` / `60ff367876c6` |
| R6 | 2026-10-15 | Set up job | 128.0s | 25.0s | 412% | [#650](https://github.com/githubnext/gh-aw-test/actions/runs/38687065162) | `5eb4c298ec` / `5eb4c298ecba` |
| R7 | 2026-10-15 | Setup Scripts | 33.0s | 5.0s | 560% | [#650](https://github.com/githubnext/gh-aw-test/actions/runs/38687065162) | `5eb4c298ec` / `5eb4c298ecba` |

### Major step times for job `conclusion` (`main`, using samples)

![Major step times for conclusion, main, using samples](steps-conclusion-main-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-04 | Set up job | 42.0s | 24.5s | 71% | [#478](https://github.com/githubnext/gh-aw-test/actions/runs/33833352495) | `76182db3ee` / `76182db3eedf` |
| R2 | 2026-09-08 to 2026-09-09 | Set up job | 98.0s | 27.0s | 263% | [#491](https://github.com/githubnext/gh-aw-test/actions/runs/34183526364) | `4fbd3efbb3` / `4fbd3efbb3c2` |
| R3 | 2026-09-13 to 2026-09-18 | Set up job | 70.0s | 34.0s | 106% | [#526](https://github.com/githubnext/gh-aw-test/actions/runs/35051876292) | `ac594b6525` / `ac594b6525e3` |
| R4 | 2026-09-22 | Set up job | 78.0s | 28.5s | 174% | [#553](https://github.com/githubnext/gh-aw-test/actions/runs/35683238457) | `c3baa0c672` / `c3baa0c6728f` |
| R5 | 2026-09-25 | Set up job | 54.0s | 31.5s | 71% | [#565](https://github.com/githubnext/gh-aw-test/actions/runs/36090369897) | `8dcc371713` / `8dcc371713b1` |
| R6 | 2026-09-29 | Set up job | 53.0s | 25.5s | 108% | [#581](https://github.com/githubnext/gh-aw-test/actions/runs/36517314719) | `09e40b7fb1` / `09e40b7fb1d4` |
| R7 | 2026-10-04 | Set up job | 46.0s | 25.0s | 84% | [#604](https://github.com/githubnext/gh-aw-test/actions/runs/37259935923) | `a5e1584ee9` / `a5e1584ee9ac` |
| R8 | 2026-10-08 | Set up job | 44.0s | 25.5s | 73% | [#616](https://github.com/githubnext/gh-aw-test/actions/runs/37723139085) | `23403d903f` / `23403d903f5c` |
| R9 | 2026-10-14 to 2026-10-15 | Set up job | 44.0s | 26.0s | 69% | [#640](https://github.com/githubnext/gh-aw-test/actions/runs/38506297635) | `d06e0878f2` / `d06e0878f2b7` |

## Run, job & step times (`released`, using samples)

**193 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for released, using samples](timing-released-samples.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 193 | 125.0s | 174.8s |
| Workflow start to proxy step | 193 | 68.0s | 97.0s |
| Proxy step to first reasoning/sample | 193 | 0.0s | 1.0s |
| Job `activation` | 193 | 18.0s | 38.6s |
| Job `agent` | 193 | 42.0s | 60.8s |
| Job `detection` | 0 | n/a | n/a |
| Job `safe_outputs` | 193 | 13.0s | 23.0s |
| Job `conclusion` | 193 | 16.0s | 27.0s |
| Major step `Download container images` | 193 | 10.0s | 18.0s |
| Major step `Install ripgrep` | 8 | 9.0s | 18.0s |
| Major step `Start MCP Gateway` | 193 | 7.0s | 12.0s |
| Major step `Install GitHub Copilot CLI` | 192 | 4.0s | 12.0s |
| Major step `Set up job` | 162 | 3.0s | 4.0s |
| Major step `Setup Scripts` | 179 | 2.0s | 4.0s |
| Major step `Install AWF binary` | 14 | 2.0s | 2.0s |
| Major step `Download activation artifact` | 65 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 37 | 2.0s | 2.0s |
| Major step `Stop MCP Gateway` | 24 | 2.0s | 2.0s |
| Major step `Checkout repository` | 33 | 2.0s | 3.0s |
| Major step `Upload agent output fallback artifact` | 6 | 2.0s | 2.0s |
| Major step `Checkout repository (gh-aw default)` | 1 | 2.0s | 2.0s |

### Major step times for job `activation` (`released`, using samples)

![Major step times for activation, released, using samples](steps-activation-released-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-08 | Checkout .github and .agents folders | 18.0s | 2.0s | 800% | [#500](https://github.com/githubnext/gh-aw-test/actions/runs/34435478909) | `v0.88.7` / `bde367913ade` |
| R2 | 2026-09-08 | Setup Scripts | 18.0s | 2.0s | 800% | [#504](https://github.com/githubnext/gh-aw-test/actions/runs/34560707477) | `v0.88.7` / `bde367913ade` |
| R3 | 2026-09-08 | Upload activation artifact | 17.0s | 2.0s | 750% | [#515](https://github.com/githubnext/gh-aw-test/actions/runs/34804532324) | `v0.88.7` / `bde367913ade` |
| R4 | 2026-09-14 | Set up job | 41.0s | 5.5s | 645% | [#524](https://github.com/githubnext/gh-aw-test/actions/runs/34929217400) | `v0.89.15` / `0fac96fb53dc` |
| R5 | 2026-09-14 | Setup Scripts | 18.0s | 2.0s | 800% | [#524](https://github.com/githubnext/gh-aw-test/actions/runs/34929217400) | `v0.89.15` / `0fac96fb53dc` |
| R6 | 2026-09-19 | Set up job | 43.0s | 5.0s | 760% | [#551](https://github.com/githubnext/gh-aw-test/actions/runs/35562911186) | `v0.89.17` / `004574777203` |
| R7 | 2026-09-19 | Setup Scripts | 20.0s | 2.5s | 700% | [#551](https://github.com/githubnext/gh-aw-test/actions/runs/35562911186) | `v0.89.17` / `004574777203` |
| R8 | 2026-09-22 | Set up job | 57.0s | 6.0s | 850% | [#557](https://github.com/githubnext/gh-aw-test/actions/runs/35814343135) | `v0.89.19` / `5f477dc0d3df` |
| R9 | 2026-09-27 | Checkout .github and .agents folders | 21.0s | 2.0s | 950% | [#579](https://github.com/githubnext/gh-aw-test/actions/runs/36383138156) | `v0.89.22` / `60480baa868f` |
| R10 | 2026-09-27 | Setup Scripts | 64.0s | 2.0s | 3100% | [#579](https://github.com/githubnext/gh-aw-test/actions/runs/36383138156) | `v0.89.22` / `60480baa868f` |

### Major step times for job `agent` (`released`, using samples)

![Major step times for agent, released, using samples](steps-agent-released-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-04 | Install GitHub Copilot CLI | 29.0s | 10.0s | 190% | [#489](https://github.com/githubnext/gh-aw-test/actions/runs/34083680068) | `v0.88.4` / `82239c030d6a` |
| R2 | 2026-09-08 | Download container images | 15.0s | 5.0s | 200% | [#546](https://github.com/githubnext/gh-aw-test/actions/runs/35488777022) | `v0.88.7` / `bde367913ade` |
| R3 | 2026-09-11 to 2026-09-14 | Download container images | 18.0s | 6.5s | 177% | [#508](https://github.com/githubnext/gh-aw-test/actions/runs/34671669720) | `v0.89.7` / `93c3fc498dbd` |
| R4 | 2026-09-14 | Install GitHub Copilot CLI | 16.0s | 3.5s | 357% | [#558](https://github.com/githubnext/gh-aw-test/actions/runs/35818775491) | `v0.89.15` / `0fac96fb53dc` |
| R5 | 2026-09-19 | Download container images | 22.0s | 10.5s | 110% | [#551](https://github.com/githubnext/gh-aw-test/actions/runs/35562911186) | `v0.89.17` / `004574777203` |
| R6 | 2026-09-23 | Download container images | 21.0s | 9.0s | 133% | [#641](https://github.com/githubnext/gh-aw-test/actions/runs/38510546293) | `v0.89.21` / `c35393777e56` |
| R7 | 2026-09-23 | Install GitHub Copilot CLI | 15.0s | 4.0s | 275% | [#571](https://github.com/githubnext/gh-aw-test/actions/runs/36221021322) | `v0.89.21` / `c35393777e56` |
| R8 | 2026-09-23 | Start MCP Gateway | 24.0s | 7.5s | 220% | [#578](https://github.com/githubnext/gh-aw-test/actions/runs/36378507184) | `v0.89.21` / `c35393777e56` |
| R9 | 2026-10-14 | Install GitHub Copilot CLI | 21.0s | 7.0s | 200% | [#648](https://github.com/githubnext/gh-aw-test/actions/runs/38683926531) | `v0.91.14` / `667d4531279b` |
| R10 | 2026-10-14 | Start MCP Gateway | 20.0s | 6.0s | 233% | [#651](https://github.com/githubnext/gh-aw-test/actions/runs/38692101200) | `v0.91.12` / `5708fc68e91f` |

### Major step times for job `detection` (`released`, using samples)

![Major step times for detection, released, using samples](steps-detection-released-samples.svg)

#### Candidate regressions (last six weeks)

No candidate regressions in the last six weeks.

### Major step times for job `safe_outputs` (`released`, using samples)

![Major step times for safe_outputs, released, using samples](steps-safe-outputs-released-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-07 to 2026-09-08 | Set up job | 24.0s | 3.5s | 586% | [#537](https://github.com/githubnext/gh-aw-test/actions/runs/35305388904) | `v0.88.7` / `bde367913ade` |
| R2 | 2026-09-13 | Set up job | 18.0s | 6.0s | 200% | [#516](https://github.com/githubnext/gh-aw-test/actions/runs/34806250484) | `v0.89.12` / `3c53578b6037` |
| R3 | 2026-09-22 | Set up job | 26.0s | 6.0s | 333% | [#557](https://github.com/githubnext/gh-aw-test/actions/runs/35814343135) | `v0.89.19` / `5f477dc0d3df` |
| R4 | 2026-10-05 | Setup Scripts | 38.0s | 2.0s | 1800% | [#610](https://github.com/githubnext/gh-aw-test/actions/runs/37417069047) | `v0.91.0` / `af1e2fd1ef1e` |
| R5 | 2026-10-15 | Setup Scripts | 13.0s | 3.0s | 333% | [#652](https://github.com/githubnext/gh-aw-test/actions/runs/38695759325) | `v0.92.0` / `a68f5a9436d2` |

### Major step times for job `conclusion` (`released`, using samples)

![Major step times for conclusion, released, using samples](steps-conclusion-released-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-08 | Set up job | 28.0s | 6.0s | 367% | [#496](https://github.com/githubnext/gh-aw-test/actions/runs/34309466322) | `v0.88.7` / `bde367913ade` |
| R2 | 2026-09-08 | Setup Scripts | 16.0s | 2.0s | 700% | [#527](https://github.com/githubnext/gh-aw-test/actions/runs/35054650339) | `v0.88.7` / `bde367913ade` |
| R3 | 2026-09-13 to 2026-09-14 | Set up job | 48.0s | 5.5s | 773% | [#520](https://github.com/githubnext/gh-aw-test/actions/runs/34816201643) | `v0.89.12` / `3c53578b6037` |
| R4 | 2026-09-22 | Set up job | 73.0s | 3.5s | 1986% | [#557](https://github.com/githubnext/gh-aw-test/actions/runs/35814343135) | `v0.89.19` / `5f477dc0d3df` |
| R5 | 2026-10-05 | Setup Scripts | 13.0s | 2.0s | 550% | [#610](https://github.com/githubnext/gh-aw-test/actions/runs/37417069047) | `v0.91.0` / `af1e2fd1ef1e` |

## Method

Each section fixes both independent dimensions: gh-aw source (`main` or combined stable/pre-release `released`) and execution mode (`inference` or `samples`). Only overall-successful `workflow_dispatch` runs with a successful `agent` job are included. Candidate regression baselines use up to ten preceding observations from the same section and step; displayed regression episodes are limited to the six weeks before report generation. A step is graphed when it has a sustained cost, recent slowdown, or recent regression. Runs with missing compiler metadata remain in CSV/JSON but are excluded from graphs.

For inference runs, `Execute GitHub Copilot CLI` is additionally split using timestamped runtime markers: **AWF startup** is step start to the AWF agent-container entrypoint, **harness startup** is that entrypoint to the first Copilot process start, and **Copilot process** is the first process start through the final process close (including retries and retry delays). Cleanup after process close remains visible only in the full step duration, while unavailable markers produce no phase value.
