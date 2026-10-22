# Performance history for `copilot-create-issue.md`

## Run, job & step times (`main`, using inference)

**122 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for main, using inference](timing-main-inference.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 122 | 345.5s | 430.9s |
| Workflow start to proxy step | 122 | 113.5s | 147.5s |
| Proxy step to first reasoning/sample | 114 | 21.0s | 28.6s |
| Copilot phase — AWF startup | 114 | 14.3s | 20.9s |
| Copilot phase — harness startup | 114 | 1.9s | 4.6s |
| Copilot phase — Copilot process | 114 | 6.5s | 9.4s |
| Job `activation` | 122 | 48.5s | 71.6s |
| Job `agent` | 122 | 89.0s | 167.9s |
| Job `detection` | 122 | 75.0s | 96.9s |
| Job `safe_outputs` | 122 | 42.0s | 67.0s |
| Job `conclusion` | 122 | 45.0s | 64.7s |
| Major step `Execute GitHub Copilot CLI` | 122 | 27.0s | 112.9s |
| Major step `Set up job` | 122 | 18.0s | 22.9s |
| Major step `Install ripgrep` | 6 | 14.0s | 19.0s |
| Major step `Download container images` | 122 | 11.0s | 18.0s |
| Major step `Start MCP Gateway` | 122 | 6.0s | 11.0s |
| Major step `Install GitHub Copilot CLI` | 122 | 5.0s | 12.0s |
| Major step `Setup Scripts` | 121 | 3.0s | 5.0s |
| Major step `Download activation artifact` | 51 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 33 | 2.0s | 2.0s |
| Major step `Checkout repository` | 27 | 2.0s | 3.0s |
| Major step `Install AWF binary` | 9 | 2.0s | 2.0s |
| Major step `Stop MCP Gateway` | 15 | 2.0s | 2.0s |
| Major step `Print firewall logs` | 2 | 2.0s | 2.0s |
| Major step `Audit pre-agent workspace` | 1 | 2.0s | 2.0s |
| Major step `Upload agent output fallback artifact` | 4 | 2.0s | 2.0s |
| Major step `Checkout repository (gh-aw default)` | 2 | 2.0s | 2.0s |

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
| R1 | 2026-09-24 | Download container images | 22.0s | 10.5s | 110% | [#560](https://github.com/githubnext/gh-aw-test/actions/runs/35950771050) | `a3f8c9f673` / `a3f8c9f67357` |
| R2 | 2026-09-24 | Execute GitHub Copilot CLI | 35.0s | 22.5s | 56% | [#560](https://github.com/githubnext/gh-aw-test/actions/runs/35950771050) | `a3f8c9f673` / `a3f8c9f67357` |
| R3 | 2026-09-24 | Start MCP Gateway | 18.0s | 5.5s | 227% | [#560](https://github.com/githubnext/gh-aw-test/actions/runs/35950771050) | `a3f8c9f673` / `a3f8c9f67357` |
| R4 | 2026-09-27 | Install GitHub Copilot CLI | 29.0s | 4.0s | 625% | [#572](https://github.com/githubnext/gh-aw-test/actions/runs/36290978751) | `ba0499c5a4` / `ba0499c5a462` |
| R5 | 2026-09-27 | Start MCP Gateway | 17.0s | 5.5s | 209% | [#576](https://github.com/githubnext/gh-aw-test/actions/runs/36373361100) | `60ff367876` / `60ff367876c6` |
| R6 | 2026-10-01 | Copilot phase — AWF startup | 31.9s | 14.1s | 125% | [#588](https://github.com/githubnext/gh-aw-test/actions/runs/36810119640) | `55f35d4bdf` / `55f35d4bdfbc` |
| R7 | 2026-10-01 | Download container images | 26.0s | 10.5s | 148% | [#588](https://github.com/githubnext/gh-aw-test/actions/runs/36810119640) | `55f35d4bdf` / `55f35d4bdfbc` |
| R8 | 2026-10-01 | Execute GitHub Copilot CLI | 47.0s | 24.5s | 92% | [#588](https://github.com/githubnext/gh-aw-test/actions/runs/36810119640) | `55f35d4bdf` / `55f35d4bdfbc` |
| R9 | 2026-10-16 to 2026-10-17 | Install GitHub Copilot CLI | 23.0s | 6.0s | 283% | [#658](https://github.com/githubnext/gh-aw-test/actions/runs/38997993206) | `d3915e4a21` / `d3915e4a2104` |
| R10 | 2026-10-17 | Copilot phase — AWF startup | 30.0s | 18.0s | 67% | [#658](https://github.com/githubnext/gh-aw-test/actions/runs/38997993206) | `d3915e4a21` / `d3915e4a2104` |

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
| R1 | 2026-09-11 | Set up job | 70.0s | 35.5s | 97% | [#502](https://github.com/githubnext/gh-aw-test/actions/runs/34557783678) | `1787de5150` / `1787de5150ac` |
| R2 | 2026-09-14 to 2026-09-18 | Set up job | 79.0s | 32.5s | 143% | [#529](https://github.com/githubnext/gh-aw-test/actions/runs/35074766458) | `0fea86e118` / `0fea86e1185f` |
| R3 | 2026-10-09 | Set up job | 131.0s | 36.5s | 259% | [#619](https://github.com/githubnext/gh-aw-test/actions/runs/37878870672) | `c268866353` / `c2688663530a` |
| R4 | 2026-10-09 | Setup Scripts | 59.0s | 3.5s | 1586% | [#619](https://github.com/githubnext/gh-aw-test/actions/runs/37878870672) | `c268866353` / `c2688663530a` |
| R5 | 2026-10-15 | Set up job | 59.0s | 34.5s | 71% | [#649](https://github.com/githubnext/gh-aw-test/actions/runs/38685973796) | `5eb4c298ec` / `5eb4c298ecba` |

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

**116 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for main, using samples](timing-main-samples.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 116 | 208.0s | 269.5s |
| Workflow start to proxy step | 116 | 102.0s | 132.5s |
| Proxy step to first reasoning/sample | 116 | 0.0s | 0.5s |
| Job `activation` | 116 | 46.0s | 73.0s |
| Job `agent` | 116 | 49.5s | 62.0s |
| Job `detection` | 0 | n/a | n/a |
| Job `safe_outputs` | 116 | 35.0s | 56.0s |
| Job `conclusion` | 116 | 39.0s | 64.0s |
| Major step `Download container images` | 116 | 10.0s | 14.5s |
| Major step `Set up job` | 116 | 9.0s | 14.5s |
| Major step `Start MCP Gateway` | 116 | 6.0s | 10.5s |
| Major step `Print firewall logs` | 1 | 5.0s | 5.0s |
| Major step `Install GitHub Copilot CLI` | 116 | 4.0s | 11.0s |
| Major step `Setup Scripts` | 115 | 3.0s | 5.0s |
| Major step `Checkout repository` | 26 | 2.0s | 3.0s |
| Major step `Install AWF binary` | 5 | 2.0s | 2.0s |
| Major step `Download activation artifact` | 41 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 21 | 2.0s | 2.0s |
| Major step `Stop MCP Gateway` | 19 | 2.0s | 2.0s |
| Major step `Upload agent output fallback artifact` | 5 | 2.0s | 2.0s |
| Major step `Checkout repository (gh-aw default)` | 6 | 2.0s | 2.0s |

### Major step times for job `activation` (`main`, using samples)

![Major step times for activation, main, using samples](steps-activation-main-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-14 to 2026-09-18 | Set up job | 111.0s | 34.5s | 222% | [#526](https://github.com/githubnext/gh-aw-test/actions/runs/35051876292) | `ac594b6525` / `ac594b6525e3` |
| R2 | 2026-09-15 | Checkout .github and .agents folders | 13.0s | 2.0s | 550% | [#526](https://github.com/githubnext/gh-aw-test/actions/runs/35051876292) | `ac594b6525` / `ac594b6525e3` |
| R3 | 2026-09-30 | Set up job | 43.0s | 25.5s | 69% | [#585](https://github.com/githubnext/gh-aw-test/actions/runs/36664634145) | `03b8f74820` / `03b8f7482069` |
| R4 | 2026-10-10 | Setup Scripts | 24.0s | 4.5s | 433% | [#624](https://github.com/githubnext/gh-aw-test/actions/runs/38020774086) | `6976a375a2` / `6976a375a288` |
| R5 | 2026-10-11 | Set up job | 86.0s | 32.0s | 169% | [#628](https://github.com/githubnext/gh-aw-test/actions/runs/38108788934) | `a1376acf2e` / `a1376acf2ead` |
| R6 | 2026-10-20 | Set up job | 62.0s | 34.0s | 82% | [#671](https://github.com/githubnext/gh-aw-test/actions/runs/39365173077) | `7363a87ff2` / `7363a87ff248` |

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
| R6 | 2026-10-20 | Download container images | 27.0s | 11.0s | 145% | [#671](https://github.com/githubnext/gh-aw-test/actions/runs/39365173077) | `7363a87ff2` / `7363a87ff248` |
| R7 | 2026-10-20 | Set up job | 21.0s | 11.0s | 91% | [#671](https://github.com/githubnext/gh-aw-test/actions/runs/39365173077) | `7363a87ff2` / `7363a87ff248` |
| R8 | 2026-10-21 | Install GitHub Copilot CLI | 17.0s | 7.0s | 143% | [#675](https://github.com/githubnext/gh-aw-test/actions/runs/39538801637) | `15d31e5375` / `15d31e5375b6` |

### Major step times for job `detection` (`main`, using samples)

![Major step times for detection, main, using samples](steps-detection-main-samples.svg)

#### Candidate regressions (last six weeks)

No candidate regressions in the last six weeks.

### Major step times for job `safe_outputs` (`main`, using samples)

![Major step times for safe_outputs, main, using samples](steps-safe-outputs-main-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-15 | Set up job | 87.0s | 38.0s | 129% | [#526](https://github.com/githubnext/gh-aw-test/actions/runs/35051876292) | `ac594b6525` / `ac594b6525e3` |
| R2 | 2026-09-27 | Set up job | 99.0s | 29.5s | 236% | [#577](https://github.com/githubnext/gh-aw-test/actions/runs/36374032160) | `60ff367876` / `60ff367876c6` |
| R3 | 2026-09-27 | Setup Scripts | 18.0s | 4.0s | 350% | [#577](https://github.com/githubnext/gh-aw-test/actions/runs/36374032160) | `60ff367876` / `60ff367876c6` |
| R4 | 2026-10-15 | Set up job | 128.0s | 25.0s | 412% | [#650](https://github.com/githubnext/gh-aw-test/actions/runs/38687065162) | `5eb4c298ec` / `5eb4c298ecba` |
| R5 | 2026-10-15 | Setup Scripts | 33.0s | 5.0s | 560% | [#650](https://github.com/githubnext/gh-aw-test/actions/runs/38687065162) | `5eb4c298ec` / `5eb4c298ecba` |

### Major step times for job `conclusion` (`main`, using samples)

![Major step times for conclusion, main, using samples](steps-conclusion-main-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-13 to 2026-09-18 | Set up job | 70.0s | 34.0s | 106% | [#526](https://github.com/githubnext/gh-aw-test/actions/runs/35051876292) | `ac594b6525` / `ac594b6525e3` |
| R2 | 2026-09-22 | Set up job | 78.0s | 28.5s | 174% | [#553](https://github.com/githubnext/gh-aw-test/actions/runs/35683238457) | `c3baa0c672` / `c3baa0c6728f` |
| R3 | 2026-09-25 | Set up job | 54.0s | 31.5s | 71% | [#565](https://github.com/githubnext/gh-aw-test/actions/runs/36090369897) | `8dcc371713` / `8dcc371713b1` |
| R4 | 2026-09-29 | Set up job | 53.0s | 25.5s | 108% | [#581](https://github.com/githubnext/gh-aw-test/actions/runs/36517314719) | `09e40b7fb1` / `09e40b7fb1d4` |
| R5 | 2026-10-04 | Set up job | 46.0s | 25.0s | 84% | [#604](https://github.com/githubnext/gh-aw-test/actions/runs/37259935923) | `a5e1584ee9` / `a5e1584ee9ac` |
| R6 | 2026-10-08 | Set up job | 44.0s | 25.5s | 73% | [#616](https://github.com/githubnext/gh-aw-test/actions/runs/37723139085) | `23403d903f` / `23403d903f5c` |
| R7 | 2026-10-14 to 2026-10-15 | Set up job | 44.0s | 26.0s | 69% | [#640](https://github.com/githubnext/gh-aw-test/actions/runs/38506297635) | `d06e0878f2` / `d06e0878f2b7` |

## Run, job & step times (`released`, using samples)

**207 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for released, using samples](timing-released-samples.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 207 | 124.0s | 172.2s |
| Workflow start to proxy step | 207 | 68.0s | 96.4s |
| Proxy step to first reasoning/sample | 207 | 0.0s | 1.0s |
| Job `activation` | 207 | 18.0s | 36.4s |
| Job `agent` | 207 | 43.0s | 60.4s |
| Job `detection` | 0 | n/a | n/a |
| Job `safe_outputs` | 207 | 13.0s | 23.0s |
| Job `conclusion` | 207 | 16.0s | 26.4s |
| Major step `Download container images` | 207 | 10.0s | 18.0s |
| Major step `Install ripgrep` | 8 | 9.0s | 18.0s |
| Major step `Start MCP Gateway` | 207 | 7.0s | 12.0s |
| Major step `Install GitHub Copilot CLI` | 206 | 4.0s | 12.0s |
| Major step `Set up job` | 173 | 3.0s | 4.0s |
| Major step `Setup Scripts` | 193 | 2.0s | 4.0s |
| Major step `Install AWF binary` | 16 | 2.0s | 2.0s |
| Major step `Download activation artifact` | 71 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 39 | 2.0s | 2.0s |
| Major step `Stop MCP Gateway` | 26 | 2.0s | 2.0s |
| Major step `Checkout repository` | 33 | 2.0s | 3.0s |
| Major step `Upload agent output fallback artifact` | 9 | 2.0s | 2.0s |
| Major step `Checkout repository (gh-aw default)` | 2 | 2.0s | 2.0s |

### Major step times for job `activation` (`released`, using samples)

![Major step times for activation, released, using samples](steps-activation-released-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-14 | Set up job | 41.0s | 5.5s | 645% | [#524](https://github.com/githubnext/gh-aw-test/actions/runs/34929217400) | `v0.89.15` / `0fac96fb53dc` |
| R2 | 2026-09-14 | Setup Scripts | 18.0s | 2.0s | 800% | [#524](https://github.com/githubnext/gh-aw-test/actions/runs/34929217400) | `v0.89.15` / `0fac96fb53dc` |
| R3 | 2026-09-19 | Set up job | 43.0s | 5.0s | 760% | [#551](https://github.com/githubnext/gh-aw-test/actions/runs/35562911186) | `v0.89.17` / `004574777203` |
| R4 | 2026-09-19 | Setup Scripts | 20.0s | 2.5s | 700% | [#551](https://github.com/githubnext/gh-aw-test/actions/runs/35562911186) | `v0.89.17` / `004574777203` |
| R5 | 2026-09-22 | Set up job | 57.0s | 6.0s | 850% | [#557](https://github.com/githubnext/gh-aw-test/actions/runs/35814343135) | `v0.89.19` / `5f477dc0d3df` |
| R6 | 2026-09-27 | Checkout .github and .agents folders | 21.0s | 2.0s | 950% | [#579](https://github.com/githubnext/gh-aw-test/actions/runs/36383138156) | `v0.89.22` / `60480baa868f` |
| R7 | 2026-09-27 | Setup Scripts | 64.0s | 2.0s | 3100% | [#579](https://github.com/githubnext/gh-aw-test/actions/runs/36383138156) | `v0.89.22` / `60480baa868f` |

### Major step times for job `agent` (`released`, using samples)

![Major step times for agent, released, using samples](steps-agent-released-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-11 to 2026-09-14 | Download container images | 18.0s | 6.5s | 177% | [#508](https://github.com/githubnext/gh-aw-test/actions/runs/34671669720) | `v0.89.7` / `93c3fc498dbd` |
| R2 | 2026-09-14 | Install GitHub Copilot CLI | 16.0s | 3.5s | 357% | [#558](https://github.com/githubnext/gh-aw-test/actions/runs/35818775491) | `v0.89.15` / `0fac96fb53dc` |
| R3 | 2026-09-19 | Download container images | 22.0s | 10.5s | 110% | [#551](https://github.com/githubnext/gh-aw-test/actions/runs/35562911186) | `v0.89.17` / `004574777203` |
| R4 | 2026-09-23 | Download container images | 21.0s | 9.0s | 133% | [#641](https://github.com/githubnext/gh-aw-test/actions/runs/38510546293) | `v0.89.21` / `c35393777e56` |
| R5 | 2026-09-23 | Install GitHub Copilot CLI | 15.0s | 4.0s | 275% | [#571](https://github.com/githubnext/gh-aw-test/actions/runs/36221021322) | `v0.89.21` / `c35393777e56` |
| R6 | 2026-09-23 | Start MCP Gateway | 24.0s | 7.5s | 220% | [#578](https://github.com/githubnext/gh-aw-test/actions/runs/36378507184) | `v0.89.21` / `c35393777e56` |
| R7 | 2026-10-14 | Install GitHub Copilot CLI | 21.0s | 7.0s | 200% | [#648](https://github.com/githubnext/gh-aw-test/actions/runs/38683926531) | `v0.91.14` / `667d4531279b` |
| R8 | 2026-10-14 | Start MCP Gateway | 20.0s | 6.0s | 233% | [#651](https://github.com/githubnext/gh-aw-test/actions/runs/38692101200) | `v0.91.12` / `5708fc68e91f` |
| R9 | 2026-10-17 | Download container images | 27.0s | 11.5s | 135% | [#669](https://github.com/githubnext/gh-aw-test/actions/runs/39203708774) | `v0.92.5` / `cbc32699c3d6` |
| R10 | 2026-10-17 | Start MCP Gateway | 32.0s | 6.5s | 392% | [#673](https://github.com/githubnext/gh-aw-test/actions/runs/39375395453) | `v0.92.5` / `cbc32699c3d6` |

### Major step times for job `detection` (`released`, using samples)

![Major step times for detection, released, using samples](steps-detection-released-samples.svg)

#### Candidate regressions (last six weeks)

No candidate regressions in the last six weeks.

### Major step times for job `safe_outputs` (`released`, using samples)

![Major step times for safe_outputs, released, using samples](steps-safe-outputs-released-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-13 | Set up job | 18.0s | 6.0s | 200% | [#516](https://github.com/githubnext/gh-aw-test/actions/runs/34806250484) | `v0.89.12` / `3c53578b6037` |
| R2 | 2026-09-22 | Set up job | 26.0s | 6.0s | 333% | [#557](https://github.com/githubnext/gh-aw-test/actions/runs/35814343135) | `v0.89.19` / `5f477dc0d3df` |
| R3 | 2026-10-05 | Setup Scripts | 38.0s | 2.0s | 1800% | [#610](https://github.com/githubnext/gh-aw-test/actions/runs/37417069047) | `v0.91.0` / `af1e2fd1ef1e` |
| R4 | 2026-10-15 | Setup Scripts | 18.0s | 4.0s | 350% | [#672](https://github.com/githubnext/gh-aw-test/actions/runs/39369618109) | `v0.92.0` / `a68f5a9436d2` |

### Major step times for job `conclusion` (`released`, using samples)

![Major step times for conclusion, released, using samples](steps-conclusion-released-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-13 to 2026-09-14 | Set up job | 48.0s | 5.5s | 773% | [#520](https://github.com/githubnext/gh-aw-test/actions/runs/34816201643) | `v0.89.12` / `3c53578b6037` |
| R2 | 2026-09-22 | Set up job | 73.0s | 3.5s | 1986% | [#557](https://github.com/githubnext/gh-aw-test/actions/runs/35814343135) | `v0.89.19` / `5f477dc0d3df` |
| R3 | 2026-10-05 | Setup Scripts | 13.0s | 2.0s | 550% | [#610](https://github.com/githubnext/gh-aw-test/actions/runs/37417069047) | `v0.91.0` / `af1e2fd1ef1e` |

## Method

Each section fixes both independent dimensions: gh-aw source (`main` or combined stable/pre-release `released`) and execution mode (`inference` or `samples`). Only overall-successful `workflow_dispatch` runs with a successful `agent` job are included. Candidate regression baselines use up to ten preceding observations from the same section and step; displayed regression episodes are limited to the six weeks before report generation. A step is graphed when it has a sustained cost, recent slowdown, or recent regression. Runs with missing compiler metadata remain in CSV/JSON but are excluded from graphs.

For inference runs, `Execute GitHub Copilot CLI` is additionally split using timestamped runtime markers: **AWF startup** is step start to the AWF agent-container entrypoint, **harness startup** is that entrypoint to the first Copilot process start, and **Copilot process** is the first process start through the final process close (including retries and retry delays). Cleanup after process close remains visible only in the full step duration, while unavailable markers produce no phase value.
