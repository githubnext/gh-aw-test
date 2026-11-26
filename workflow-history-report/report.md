# Performance history for `copilot-create-issue.md`

## Run, job & step times (`main`, using inference)

**130 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for main, using inference](timing-main-inference.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 130 | 349.0s | 430.1s |
| Workflow start to proxy step | 130 | 115.0s | 148.1s |
| Proxy step to first reasoning/sample | 122 | 21.5s | 28.6s |
| Copilot phase — AWF startup | 122 | 14.3s | 21.0s |
| Copilot phase — harness startup | 122 | 2.0s | 6.2s |
| Copilot phase — Copilot process | 122 | 6.3s | 9.2s |
| Job `activation` | 130 | 49.5s | 74.0s |
| Job `agent` | 130 | 89.0s | 167.1s |
| Job `detection` | 130 | 76.0s | 97.1s |
| Job `safe_outputs` | 130 | 43.0s | 67.2s |
| Job `conclusion` | 130 | 45.5s | 65.1s |
| Major step `Execute GitHub Copilot CLI` | 130 | 27.5s | 112.1s |
| Major step `Set up job` | 130 | 18.0s | 23.0s |
| Major step `Install ripgrep` | 6 | 14.0s | 19.0s |
| Major step `Download container images` | 130 | 11.0s | 18.0s |
| Major step `Start MCP Gateway` | 130 | 6.0s | 11.0s |
| Major step `Install GitHub Copilot CLI` | 130 | 4.0s | 12.1s |
| Major step `Setup Scripts` | 129 | 3.0s | 5.0s |
| Major step `Download activation artifact` | 52 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 35 | 2.0s | 2.0s |
| Major step `Checkout repository` | 27 | 2.0s | 3.0s |
| Major step `Install AWF binary` | 12 | 2.0s | 2.0s |
| Major step `Stop MCP Gateway` | 17 | 2.0s | 2.0s |
| Major step `Print firewall logs` | 2 | 2.0s | 2.0s |
| Major step `Audit pre-agent workspace` | 1 | 2.0s | 2.0s |
| Major step `Upload agent output fallback artifact` | 4 | 2.0s | 2.0s |
| Major step `Checkout repository (gh-aw default)` | 3 | 2.0s | 2.0s |
| Major step `Redact secrets in logs` | 1 | 2.0s | 2.0s |

### Major step times for job `activation` (`main`, using inference)

![Major step times for activation, main, using inference](steps-activation-main-inference.svg)

#### Candidate regressions (last six weeks)

No candidate regressions in the last six weeks.

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
| R11 | 2026-10-25 | Download container images | 27.0s | 13.5s | 100% | [#695](https://github.com/githubnext/gh-aw-test/actions/runs/40157645986) | `2301a1bb74` / `2301a1bb74f2` |

### Major step times for job `detection` (`main`, using inference)

![Major step times for detection, main, using inference](steps-detection-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-30 | Execute threat detection with AWF | 66.0s | 28.5s | 132% | [#584](https://github.com/githubnext/gh-aw-test/actions/runs/36663803035) | `03b8f74820` / `03b8f7482069` |
| R2 | 2026-09-30 | Install GitHub Copilot CLI | 24.0s | 6.0s | 300% | [#584](https://github.com/githubnext/gh-aw-test/actions/runs/36663803035) | `03b8f74820` / `03b8f7482069` |
| R3 | 2026-10-03 | Install GitHub Copilot CLI | 26.0s | 8.0s | 225% | [#596](https://github.com/githubnext/gh-aw-test/actions/runs/37093124717) | `fe02b64412` / `fe02b644122e` |
| R4 | 2026-10-11 | Install GitHub Copilot CLI | 22.0s | 10.0s | 120% | [#627](https://github.com/githubnext/gh-aw-test/actions/runs/38108164405) | `a1376acf2e` / `a1376acf2ead` |
| R5 | 2026-10-22 | Install GitHub Copilot CLI | 24.0s | 7.5s | 220% | [#679](https://github.com/githubnext/gh-aw-test/actions/runs/39715911390) | `2b01e8ed2a` / `2b01e8ed2a27` |

### Major step times for job `safe_outputs` (`main`, using inference)

![Major step times for safe_outputs, main, using inference](steps-safe-outputs-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-14 to 2026-09-18 | Set up job | 79.0s | 32.5s | 143% | [#529](https://github.com/githubnext/gh-aw-test/actions/runs/35074766458) | `0fea86e118` / `0fea86e1185f` |
| R2 | 2026-10-09 | Set up job | 131.0s | 36.5s | 259% | [#619](https://github.com/githubnext/gh-aw-test/actions/runs/37878870672) | `c268866353` / `c2688663530a` |
| R3 | 2026-10-09 | Setup Scripts | 59.0s | 3.5s | 1586% | [#619](https://github.com/githubnext/gh-aw-test/actions/runs/37878870672) | `c268866353` / `c2688663530a` |
| R4 | 2026-10-15 | Set up job | 59.0s | 34.5s | 71% | [#649](https://github.com/githubnext/gh-aw-test/actions/runs/38685973796) | `5eb4c298ec` / `5eb4c298ecba` |
| R5 | 2026-10-28 | Set up job | 57.0s | 33.5s | 70% | [#711](https://github.com/githubnext/gh-aw-test/actions/runs/40810886681) | `0bb0365790` / `0bb036579091` |

### Major step times for job `conclusion` (`main`, using inference)

![Major step times for conclusion, main, using inference](steps-conclusion-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-10-04 | Set up job | 49.0s | 32.0s | 53% | [#599](https://github.com/githubnext/gh-aw-test/actions/runs/37176542463) | `054871a707` / `054871a7076b` |
| R2 | 2026-10-15 | Set up job | 78.0s | 32.5s | 140% | [#645](https://github.com/githubnext/gh-aw-test/actions/runs/38675409397) | `e7bc6056a7` / `e7bc6056a784` |
| R3 | 2026-10-22 | Set up job | 54.0s | 32.5s | 66% | [#679](https://github.com/githubnext/gh-aw-test/actions/runs/39715911390) | `2b01e8ed2a` / `2b01e8ed2a27` |

## Run, job & step times (`released`, using inference)

**36 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for released, using inference](timing-released-inference.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 36 | 230.5s | 356.0s |
| Workflow start to proxy step | 36 | 64.0s | 98.0s |
| Proxy step to first reasoning/sample | 36 | 21.4s | 28.5s |
| Copilot phase — AWF startup | 36 | 13.5s | 18.4s |
| Copilot phase — harness startup | 36 | 2.2s | 5.5s |
| Copilot phase — Copilot process | 36 | 7.7s | 8.8s |
| Job `activation` | 36 | 17.0s | 51.5s |
| Job `agent` | 36 | 82.5s | 157.5s |
| Job `detection` | 36 | 54.5s | 88.0s |
| Job `safe_outputs` | 36 | 12.0s | 33.0s |
| Job `conclusion` | 36 | 16.0s | 25.5s |
| Major step `Execute GitHub Copilot CLI` | 36 | 29.5s | 115.5s |
| Major step `Download container images` | 36 | 12.0s | 18.0s |
| Major step `Install ripgrep` | 3 | 12.0s | 14.4s |
| Major step `Start MCP Gateway` | 36 | 6.0s | 9.5s |
| Major step `Install GitHub Copilot CLI` | 36 | 4.0s | 9.5s |
| Major step `Set up job` | 34 | 3.0s | 4.7s |
| Major step `Setup Scripts` | 35 | 3.0s | 4.0s |
| Major step `Stop MCP Gateway` | 6 | 2.0s | 2.0s |
| Major step `Install AWF binary` | 3 | 2.0s | 2.0s |
| Major step `Download activation artifact` | 11 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 8 | 2.0s | 2.0s |
| Major step `Checkout repository` | 11 | 2.0s | 2.0s |
| Major step `Upload agent output fallback artifact` | 1 | 2.0s | 2.0s |

### Major step times for job `activation` (`released`, using inference)

![Major step times for activation, released, using inference](steps-activation-released-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-22 | Set up job | 37.0s | 3.0s | 1133% | [#556](https://github.com/githubnext/gh-aw-test/actions/runs/35813644549) | `v0.89.19` / `5f477dc0d3df` |
| R2 | 2026-10-23 | Set up job | 31.0s | 3.0s | 933% | [#691](https://github.com/githubnext/gh-aw-test/actions/runs/40057619697) | `v0.93.3` / `317d9005a6bc` |

### Major step times for job `agent` (`released`, using inference)

![Major step times for agent, released, using inference](steps-agent-released-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-22 | Set up job | 18.0s | 3.0s | 500% | [#556](https://github.com/githubnext/gh-aw-test/actions/runs/35813644549) | `v0.89.19` / `5f477dc0d3df` |
| R2 | 2026-10-23 | Set up job | 20.0s | 3.0s | 567% | [#691](https://github.com/githubnext/gh-aw-test/actions/runs/40057619697) | `v0.93.3` / `317d9005a6bc` |

### Major step times for job `detection` (`released`, using inference)

![Major step times for detection, released, using inference](steps-detection-released-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-22 | Set up job | 23.0s | 2.0s | 1050% | [#556](https://github.com/githubnext/gh-aw-test/actions/runs/35813644549) | `v0.89.19` / `5f477dc0d3df` |
| R2 | 2026-10-23 | Set up job | 25.0s | 2.5s | 900% | [#691](https://github.com/githubnext/gh-aw-test/actions/runs/40057619697) | `v0.93.3` / `317d9005a6bc` |

### Major step times for job `safe_outputs` (`released`, using inference)

![Major step times for safe_outputs, released, using inference](steps-safe-outputs-released-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-22 | Set up job | 45.0s | 3.0s | 1400% | [#556](https://github.com/githubnext/gh-aw-test/actions/runs/35813644549) | `v0.89.19` / `5f477dc0d3df` |
| R2 | 2026-10-23 | Set up job | 20.0s | 3.0s | 567% | [#691](https://github.com/githubnext/gh-aw-test/actions/runs/40057619697) | `v0.93.3` / `317d9005a6bc` |

### Major step times for job `conclusion` (`released`, using inference)

![Major step times for conclusion, released, using inference](steps-conclusion-released-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-22 | Set up job | 23.0s | 3.0s | 667% | [#556](https://github.com/githubnext/gh-aw-test/actions/runs/35813644549) | `v0.89.19` / `5f477dc0d3df` |
| R2 | 2026-10-23 | Set up job | 35.0s | 3.0s | 1067% | [#691](https://github.com/githubnext/gh-aw-test/actions/runs/40057619697) | `v0.93.3` / `317d9005a6bc` |

## Run, job & step times (`main`, using samples)

**123 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for main, using samples](timing-main-samples.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 123 | 208.0s | 269.8s |
| Workflow start to proxy step | 123 | 102.0s | 132.8s |
| Proxy step to first reasoning/sample | 123 | 0.0s | 1.0s |
| Job `activation` | 123 | 46.0s | 72.4s |
| Job `agent` | 123 | 50.0s | 62.0s |
| Job `detection` | 0 | n/a | n/a |
| Job `safe_outputs` | 123 | 35.0s | 57.8s |
| Job `conclusion` | 123 | 39.0s | 62.8s |
| Major step `Download container images` | 123 | 10.0s | 15.0s |
| Major step `Set up job` | 123 | 9.0s | 14.8s |
| Major step `Start MCP Gateway` | 123 | 6.0s | 10.8s |
| Major step `Print firewall logs` | 1 | 5.0s | 5.0s |
| Major step `Install GitHub Copilot CLI` | 123 | 4.0s | 11.0s |
| Major step `Setup Scripts` | 122 | 3.0s | 5.0s |
| Major step `Checkout repository` | 26 | 2.0s | 3.0s |
| Major step `Install AWF binary` | 6 | 2.0s | 2.0s |
| Major step `Download activation artifact` | 42 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 22 | 2.0s | 2.0s |
| Major step `Stop MCP Gateway` | 20 | 2.0s | 2.0s |
| Major step `Upload agent output fallback artifact` | 6 | 2.0s | 2.0s |
| Major step `Checkout repository (gh-aw default)` | 7 | 2.0s | 2.0s |

### Major step times for job `activation` (`main`, using samples)

![Major step times for activation, main, using samples](steps-activation-main-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-14 to 2026-09-18 | Set up job | 111.0s | 34.5s | 222% | [#526](https://github.com/githubnext/gh-aw-test/actions/runs/35051876292) | `ac594b6525` / `ac594b6525e3` |
| R2 | 2026-09-30 | Set up job | 43.0s | 25.5s | 69% | [#585](https://github.com/githubnext/gh-aw-test/actions/runs/36664634145) | `03b8f74820` / `03b8f7482069` |
| R3 | 2026-10-10 | Setup Scripts | 24.0s | 4.5s | 433% | [#624](https://github.com/githubnext/gh-aw-test/actions/runs/38020774086) | `6976a375a2` / `6976a375a288` |
| R4 | 2026-10-11 | Set up job | 86.0s | 32.0s | 169% | [#628](https://github.com/githubnext/gh-aw-test/actions/runs/38108788934) | `a1376acf2e` / `a1376acf2ead` |
| R5 | 2026-10-20 | Set up job | 62.0s | 34.0s | 82% | [#671](https://github.com/githubnext/gh-aw-test/actions/runs/39365173077) | `7363a87ff2` / `7363a87ff248` |

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
| R1 | 2026-09-27 | Set up job | 99.0s | 29.5s | 236% | [#577](https://github.com/githubnext/gh-aw-test/actions/runs/36374032160) | `60ff367876` / `60ff367876c6` |
| R2 | 2026-09-27 | Setup Scripts | 18.0s | 4.0s | 350% | [#577](https://github.com/githubnext/gh-aw-test/actions/runs/36374032160) | `60ff367876` / `60ff367876c6` |
| R3 | 2026-10-15 | Set up job | 128.0s | 25.0s | 412% | [#650](https://github.com/githubnext/gh-aw-test/actions/runs/38687065162) | `5eb4c298ec` / `5eb4c298ecba` |
| R4 | 2026-10-15 | Setup Scripts | 33.0s | 5.0s | 560% | [#650](https://github.com/githubnext/gh-aw-test/actions/runs/38687065162) | `5eb4c298ec` / `5eb4c298ecba` |
| R5 | 2026-10-27 to 2026-10-28 | Set up job | 78.0s | 26.5s | 194% | [#704](https://github.com/githubnext/gh-aw-test/actions/runs/40444485731) | `6c387d00c7` / `6c387d00c750` |

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
| R8 | 2026-10-27 | Set up job | 36.0s | 24.0s | 50% | [#704](https://github.com/githubnext/gh-aw-test/actions/runs/40444485731) | `6c387d00c7` / `6c387d00c750` |

## Run, job & step times (`released`, using samples)

**226 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for released, using samples](timing-released-samples.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 226 | 125.0s | 172.5s |
| Workflow start to proxy step | 226 | 68.0s | 95.5s |
| Proxy step to first reasoning/sample | 226 | 0.0s | 1.0s |
| Job `activation` | 226 | 18.0s | 34.5s |
| Job `agent` | 226 | 43.0s | 61.5s |
| Job `detection` | 0 | n/a | n/a |
| Job `safe_outputs` | 226 | 13.0s | 23.0s |
| Job `conclusion` | 226 | 16.0s | 27.0s |
| Major step `Download container images` | 226 | 10.0s | 19.0s |
| Major step `Install ripgrep` | 8 | 9.0s | 18.0s |
| Major step `Start MCP Gateway` | 226 | 7.0s | 12.0s |
| Major step `Install GitHub Copilot CLI` | 225 | 4.0s | 12.0s |
| Major step `Set up job` | 190 | 3.0s | 5.0s |
| Major step `Setup Scripts` | 212 | 2.0s | 4.0s |
| Major step `Install AWF binary` | 19 | 2.0s | 2.0s |
| Major step `Download activation artifact` | 78 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 46 | 2.0s | 2.0s |
| Major step `Stop MCP Gateway` | 28 | 2.0s | 2.0s |
| Major step `Checkout repository` | 33 | 2.0s | 3.0s |
| Major step `Upload agent output fallback artifact` | 11 | 2.0s | 2.0s |
| Major step `Checkout repository (gh-aw default)` | 3 | 2.0s | 2.0s |

### Major step times for job `activation` (`released`, using samples)

![Major step times for activation, released, using samples](steps-activation-released-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-19 | Set up job | 43.0s | 5.0s | 760% | [#551](https://github.com/githubnext/gh-aw-test/actions/runs/35562911186) | `v0.89.17` / `004574777203` |
| R2 | 2026-09-19 | Setup Scripts | 20.0s | 2.5s | 700% | [#551](https://github.com/githubnext/gh-aw-test/actions/runs/35562911186) | `v0.89.17` / `004574777203` |
| R3 | 2026-09-22 | Set up job | 57.0s | 6.0s | 850% | [#557](https://github.com/githubnext/gh-aw-test/actions/runs/35814343135) | `v0.89.19` / `5f477dc0d3df` |
| R4 | 2026-09-27 | Checkout .github and .agents folders | 21.0s | 2.0s | 950% | [#579](https://github.com/githubnext/gh-aw-test/actions/runs/36383138156) | `v0.89.22` / `60480baa868f` |
| R5 | 2026-09-27 | Setup Scripts | 64.0s | 2.0s | 3100% | [#579](https://github.com/githubnext/gh-aw-test/actions/runs/36383138156) | `v0.89.22` / `60480baa868f` |
| R6 | 2026-10-23 | Set up job | 33.0s | 2.5s | 1220% | [#692](https://github.com/githubnext/gh-aw-test/actions/runs/40058412852) | `v0.93.3` / `317d9005a6bc` |

### Major step times for job `agent` (`released`, using samples)

![Major step times for agent, released, using samples](steps-agent-released-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-19 | Download container images | 22.0s | 10.5s | 110% | [#551](https://github.com/githubnext/gh-aw-test/actions/runs/35562911186) | `v0.89.17` / `004574777203` |
| R2 | 2026-09-23 | Download container images | 21.0s | 9.0s | 133% | [#641](https://github.com/githubnext/gh-aw-test/actions/runs/38510546293) | `v0.89.21` / `c35393777e56` |
| R3 | 2026-09-23 | Install GitHub Copilot CLI | 15.0s | 4.0s | 275% | [#571](https://github.com/githubnext/gh-aw-test/actions/runs/36221021322) | `v0.89.21` / `c35393777e56` |
| R4 | 2026-09-23 | Start MCP Gateway | 24.0s | 7.5s | 220% | [#578](https://github.com/githubnext/gh-aw-test/actions/runs/36378507184) | `v0.89.21` / `c35393777e56` |
| R5 | 2026-10-14 | Install GitHub Copilot CLI | 21.0s | 7.0s | 200% | [#648](https://github.com/githubnext/gh-aw-test/actions/runs/38683926531) | `v0.91.14` / `667d4531279b` |
| R6 | 2026-10-14 | Start MCP Gateway | 20.0s | 6.0s | 233% | [#651](https://github.com/githubnext/gh-aw-test/actions/runs/38692101200) | `v0.91.12` / `5708fc68e91f` |
| R7 | 2026-10-17 | Download container images | 27.0s | 10.5s | 157% | [#669](https://github.com/githubnext/gh-aw-test/actions/runs/39203708774) | `v0.92.5` / `cbc32699c3d6` |
| R8 | 2026-10-17 | Start MCP Gateway | 32.0s | 6.0s | 433% | [#673](https://github.com/githubnext/gh-aw-test/actions/runs/39375395453) | `v0.92.5` / `cbc32699c3d6` |
| R9 | 2026-10-22 | Download container images | 26.0s | 16.0s | 62% | [#701](https://github.com/githubnext/gh-aw-test/actions/runs/40269048729) | `v0.93.1` / `310317364125` |
| R10 | 2026-10-23 | Set up job | 13.0s | 2.0s | 550% | [#692](https://github.com/githubnext/gh-aw-test/actions/runs/40058412852) | `v0.93.3` / `317d9005a6bc` |
| R11 | 2026-10-25 | Install GitHub Copilot CLI | 19.0s | 3.0s | 533% | [#709](https://github.com/githubnext/gh-aw-test/actions/runs/40631906382) | `v0.93.5` / `32ecafbc061c` |
| R12 | 2026-10-25 | Start MCP Gateway | 15.0s | 5.0s | 200% | [#709](https://github.com/githubnext/gh-aw-test/actions/runs/40631906382) | `v0.93.5` / `32ecafbc061c` |

### Major step times for job `detection` (`released`, using samples)

![Major step times for detection, released, using samples](steps-detection-released-samples.svg)

#### Candidate regressions (last six weeks)

No candidate regressions in the last six weeks.

### Major step times for job `safe_outputs` (`released`, using samples)

![Major step times for safe_outputs, released, using samples](steps-safe-outputs-released-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-22 | Set up job | 26.0s | 6.0s | 333% | [#557](https://github.com/githubnext/gh-aw-test/actions/runs/35814343135) | `v0.89.19` / `5f477dc0d3df` |
| R2 | 2026-10-05 | Setup Scripts | 38.0s | 2.0s | 1800% | [#610](https://github.com/githubnext/gh-aw-test/actions/runs/37417069047) | `v0.91.0` / `af1e2fd1ef1e` |
| R3 | 2026-10-15 | Setup Scripts | 18.0s | 4.0s | 350% | [#672](https://github.com/githubnext/gh-aw-test/actions/runs/39369618109) | `v0.92.0` / `a68f5a9436d2` |
| R4 | 2026-10-23 | Set up job | 26.0s | 3.0s | 767% | [#692](https://github.com/githubnext/gh-aw-test/actions/runs/40058412852) | `v0.93.3` / `317d9005a6bc` |
| R5 | 2026-10-23 | Setup Scripts | 13.0s | 3.0s | 333% | [#692](https://github.com/githubnext/gh-aw-test/actions/runs/40058412852) | `v0.93.3` / `317d9005a6bc` |

### Major step times for job `conclusion` (`released`, using samples)

![Major step times for conclusion, released, using samples](steps-conclusion-released-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-09-22 | Set up job | 73.0s | 3.5s | 1986% | [#557](https://github.com/githubnext/gh-aw-test/actions/runs/35814343135) | `v0.89.19` / `5f477dc0d3df` |
| R2 | 2026-10-05 | Setup Scripts | 13.0s | 2.0s | 550% | [#610](https://github.com/githubnext/gh-aw-test/actions/runs/37417069047) | `v0.91.0` / `af1e2fd1ef1e` |
| R3 | 2026-10-22 to 2026-10-23 | Set up job | 29.0s | 3.0s | 867% | [#692](https://github.com/githubnext/gh-aw-test/actions/runs/40058412852) | `v0.93.3` / `317d9005a6bc` |
| R4 | 2026-10-22 | Setup Scripts | 15.0s | 3.0s | 400% | [#686](https://github.com/githubnext/gh-aw-test/actions/runs/39910702968) | `v0.93.1` / `310317364125` |

## Method

Each section fixes both independent dimensions: gh-aw source (`main` or combined stable/pre-release `released`) and execution mode (`inference` or `samples`). Only overall-successful `workflow_dispatch` runs with a successful `agent` job are included. Candidate regression baselines use up to ten preceding observations from the same section and step; displayed regression episodes are limited to the six weeks before report generation. A step is graphed when it has a sustained cost, recent slowdown, or recent regression. Runs with missing compiler metadata remain in CSV/JSON but are excluded from graphs.

For inference runs, `Execute GitHub Copilot CLI` is additionally split using timestamped runtime markers: **AWF startup** is step start to the AWF agent-container entrypoint, **harness startup** is that entrypoint to the first Copilot process start, and **Copilot process** is the first process start through the final process close (including retries and retry delays). Cleanup after process close remains visible only in the full step duration, while unavailable markers produce no phase value.
