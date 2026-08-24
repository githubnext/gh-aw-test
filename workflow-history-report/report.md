# Performance history for `copilot-create-issue.md`

## Run, job & step times (`main`, using inference)

**64 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for main, using inference](timing-main-inference.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 64 | 335.5s | 442.4s |
| Workflow start to proxy step | 64 | 108.5s | 147.2s |
| Proxy step to first reasoning/sample | 64 | 20.8s | 27.4s |
| Job `activation` | 64 | 45.5s | 74.7s |
| Job `agent` | 64 | 90.0s | 172.7s |
| Job `detection` | 64 | 70.0s | 94.2s |
| Job `safe_outputs` | 64 | 37.5s | 63.4s |
| Job `conclusion` | 64 | 41.0s | 59.4s |
| Major step `Execute GitHub Copilot CLI` | 64 | 29.0s | 114.0s |
| Major step `Set up job` | 64 | 17.0s | 21.7s |
| Major step `Install ripgrep` | 6 | 14.0s | 19.0s |
| Major step `Download container images` | 64 | 11.0s | 18.7s |
| Major step `Start MCP Gateway` | 64 | 6.5s | 11.0s |
| Major step `Install GitHub Copilot CLI` | 64 | 4.0s | 7.0s |
| Major step `Setup Scripts` | 63 | 3.0s | 5.0s |
| Major step `Download activation artifact` | 35 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 24 | 2.0s | 2.0s |
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
| R1 | 2026-07-14 | Set up job | 55.0s | 30.0s | 83% | [#314](https://github.com/githubnext/gh-aw-test/actions/runs/32536396153) | `v0.82.9-54-gdf13f08917` / `df13f0891719` |
| R2 | 2026-07-25 to 2026-07-27 | Set up job | 75.0s | 29.5s | 154% | [#325](https://github.com/githubnext/gh-aw-test/actions/runs/32542948173) | `v0.83.3-17-g11d9ea9de7` / `11d9ea9de729` |
| R3 | 2026-08-08 | Set up job | 63.0s | 34.5s | 83% | [#341](https://github.com/githubnext/gh-aw-test/actions/runs/32552452139) | `v0.86.1-57-gba0a9f9589` / `ba0a9f958976` |
| R4 | 2026-08-08 | Setup Scripts | 18.0s | 3.0s | 500% | [#341](https://github.com/githubnext/gh-aw-test/actions/runs/32552452139) | `v0.86.1-57-gba0a9f9589` / `ba0a9f958976` |
| R5 | 2026-08-17 | Set up job | 48.0s | 31.5s | 52% | [#352](https://github.com/githubnext/gh-aw-test/actions/runs/32558234273) | `v0.87.0-133-g2b2cf3fb01` / `2b2cf3fb01ee` |

### Major step times for job `agent` (`main`, using inference)

![Major step times for agent, main, using inference](steps-agent-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-07-15 | Download container images | 22.0s | 12.0s | 83% | [#315](https://github.com/githubnext/gh-aw-test/actions/runs/32537059340) | `v0.82.9-134-gf0a3dd21c6` / `f0a3dd21c6e5` |
| R2 | 2026-08-07 | Download container images | 24.0s | 11.0s | 118% | [#340](https://github.com/githubnext/gh-aw-test/actions/runs/32552050221) | `v0.86.1-3-ge1e298d64b` / `e1e298d64bfa` |
| R3 | 2026-08-07 | Execute GitHub Copilot CLI | 38.0s | 22.5s | 69% | [#340](https://github.com/githubnext/gh-aw-test/actions/runs/32552050221) | `v0.86.1-3-ge1e298d64b` / `e1e298d64bfa` |
| R4 | 2026-08-14 | Execute GitHub Copilot CLI | 38.0s | 23.0s | 65% | [#349](https://github.com/githubnext/gh-aw-test/actions/runs/32556073604) | `v0.86.2-73-gc35faf436c` / `c35faf436c79` |

### Major step times for job `detection` (`main`, using inference)

![Major step times for detection, main, using inference](steps-detection-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-07-16 to 2026-07-18 | Execute GitHub Copilot CLI | 116.0s | 25.5s | 355% | [#317](https://github.com/githubnext/gh-aw-test/actions/runs/32538498682) | `v0.82.12-7-gc096ffebd2` / `c096ffebd27f` |
| R2 | 2026-07-21 | Set up job | 30.0s | 16.0s | 88% | [#321](https://github.com/githubnext/gh-aw-test/actions/runs/32540903699) | `v0.82.15-23-g2a7ac3d34e` / `2a7ac3d34e2d` |
| R3 | 2026-08-18 | Execute GitHub Copilot CLI | 50.0s | 31.5s | 59% | [#353](https://github.com/githubnext/gh-aw-test/actions/runs/32558698273) | `v0.87.1-4-g4845f00caf` / `4845f00caf46` |
| R4 | 2026-08-24 | Download container images | 12.0s | 1.0s | 1100% | [#437](https://github.com/githubnext/gh-aw-test/actions/runs/32686470697) | `5f0cc8dcc8` / `5f0cc8dcc819` |

### Major step times for job `safe_outputs` (`main`, using inference)

![Major step times for safe_outputs, main, using inference](steps-safe-outputs-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-07-21 | Set up job | 51.0s | 26.5s | 92% | [#321](https://github.com/githubnext/gh-aw-test/actions/runs/32540903699) | `v0.82.15-23-g2a7ac3d34e` / `2a7ac3d34e2d` |
| R2 | 2026-07-25 | Set up job | 61.0s | 25.5s | 139% | [#325](https://github.com/githubnext/gh-aw-test/actions/runs/32542948173) | `v0.83.3-17-g11d9ea9de7` / `11d9ea9de729` |
| R3 | 2026-08-01 to 2026-08-03 | Set up job | 89.0s | 34.5s | 158% | [#334](https://github.com/githubnext/gh-aw-test/actions/runs/32547543586) | `v0.84.3-58-g53baccde53` / `53baccde5390` |
| R4 | 2026-08-03 | Setup Scripts | 41.0s | 4.5s | 811% | [#334](https://github.com/githubnext/gh-aw-test/actions/runs/32547543586) | `v0.84.3-58-g53baccde53` / `53baccde5390` |
| R5 | 2026-08-14 to 2026-08-16 | Set up job | 69.0s | 29.0s | 138% | [#349](https://github.com/githubnext/gh-aw-test/actions/runs/32556073604) | `v0.86.2-73-gc35faf436c` / `c35faf436c79` |

### Major step times for job `conclusion` (`main`, using inference)

![Major step times for conclusion, main, using inference](steps-conclusion-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-07-15 to 2026-07-17 | Set up job | 58.0s | 26.5s | 119% | [#317](https://github.com/githubnext/gh-aw-test/actions/runs/32538498682) | `v0.82.12-7-gc096ffebd2` / `c096ffebd27f` |
| R2 | 2026-07-15 | Setup Scripts | 18.0s | 3.0s | 500% | [#315](https://github.com/githubnext/gh-aw-test/actions/runs/32537059340) | `v0.82.9-134-gf0a3dd21c6` / `f0a3dd21c6e5` |
| R3 | 2026-07-30 to 2026-08-02 | Set up job | 59.0s | 29.5s | 100% | [#333](https://github.com/githubnext/gh-aw-test/actions/runs/32547123314) | `v0.84.2-95-gf5bd99245e` / `f5bd99245e40` |
| R4 | 2026-08-03 | Setup Scripts | 14.0s | 4.0s | 250% | [#334](https://github.com/githubnext/gh-aw-test/actions/runs/32547543586) | `v0.84.3-58-g53baccde53` / `53baccde5390` |
| R5 | 2026-08-17 | Upload usage artifact | 11.0s | 1.0s | 1000% | [#352](https://github.com/githubnext/gh-aw-test/actions/runs/32558234273) | `v0.87.0-133-g2b2cf3fb01` / `2b2cf3fb01ee` |
| R6 | 2026-08-19 | Set up job | 48.0s | 28.0s | 71% | [#354](https://github.com/githubnext/gh-aw-test/actions/runs/32559121042) | `v0.87.1-44-g5d5e0af5c4` / `5d5e0af5c46c` |

## Run, job & step times (`released`, using inference)

**36 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for released, using inference](timing-released-inference.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 36 | 217.0s | 309.5s |
| Workflow start to proxy step | 36 | 62.0s | 89.5s |
| Proxy step to first reasoning/sample | 33 | 21.2s | 27.8s |
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

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-07-23 to 2026-07-24 | Set up job | 29.0s | 3.5s | 729% | [#421](https://github.com/githubnext/gh-aw-test/actions/runs/32677647094) | `v0.83.2` / `56a38be41a18` |
| R2 | 2026-07-23 | Setup Scripts | 14.0s | 2.5s | 460% | [#420](https://github.com/githubnext/gh-aw-test/actions/runs/32677398942) | `v0.83.1` / `6268b9870d9f` |

### Major step times for job `agent` (`released`, using inference)

![Major step times for agent, released, using inference](steps-agent-released-inference.svg)

#### Candidate regressions (last six weeks)

No candidate regressions in the last six weeks.

### Major step times for job `detection` (`released`, using inference)

![Major step times for detection, released, using inference](steps-detection-released-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-07-16 to 2026-07-17 | Execute GitHub Copilot CLI | 114.0s | 26.5s | 330% | [#415](https://github.com/githubnext/gh-aw-test/actions/runs/32674838482) | `v0.82.11` / `38e22c4075e3` |
| R2 | 2026-08-07 | Install GitHub Copilot CLI | 15.0s | 4.0s | 275% | [#430](https://github.com/githubnext/gh-aw-test/actions/runs/32679960433) | `v0.86.1` / `475927dfc6d1` |
| R3 | 2026-08-15 | Execute GitHub Copilot CLI | 36.0s | 23.5s | 53% | [#432](https://github.com/githubnext/gh-aw-test/actions/runs/32680559983) | `v0.86.3` / `6062cd2238b6` |

### Major step times for job `safe_outputs` (`released`, using inference)

![Major step times for safe_outputs, released, using inference](steps-safe-outputs-released-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-08-07 | Setup Scripts | 20.0s | 2.0s | 900% | [#430](https://github.com/githubnext/gh-aw-test/actions/runs/32679960433) | `v0.86.1` / `475927dfc6d1` |

### Major step times for job `conclusion` (`released`, using inference)

![Major step times for conclusion, released, using inference](steps-conclusion-released-inference.svg)

#### Candidate regressions (last six weeks)

No candidate regressions in the last six weeks.

## Run, job & step times (`main`, using samples)

**60 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for main, using samples](timing-main-samples.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 60 | 192.0s | 245.1s |
| Workflow start to proxy step | 60 | 98.0s | 121.0s |
| Proxy step to first reasoning/sample | 60 | 0.0s | 0.1s |
| Job `activation` | 60 | 45.0s | 64.1s |
| Job `agent` | 60 | 44.0s | 56.1s |
| Job `detection` | 0 | n/a | n/a |
| Job `safe_outputs` | 60 | 31.0s | 43.1s |
| Job `conclusion` | 60 | 34.0s | 53.1s |
| Major step `Download container images` | 60 | 9.0s | 13.0s |
| Major step `Set up job` | 60 | 7.0s | 12.0s |
| Major step `Start MCP Gateway` | 60 | 7.0s | 11.1s |
| Major step `Install GitHub Copilot CLI` | 60 | 4.0s | 5.0s |
| Major step `Setup Scripts` | 59 | 2.0s | 4.2s |
| Major step `Checkout repository` | 9 | 2.0s | 2.0s |
| Major step `Install AWF binary` | 3 | 2.0s | 2.0s |
| Major step `Download activation artifact` | 16 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 9 | 2.0s | 2.0s |
| Major step `Stop MCP Gateway` | 6 | 2.0s | 2.0s |

### Major step times for job `activation` (`main`, using samples)

![Major step times for activation, main, using samples](steps-activation-main-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-07-15 | Set up job | 42.0s | 27.5s | 53% | [#224](https://github.com/githubnext/gh-aw-test/actions/runs/29388180753) | `61336cb2af` / `61336cb2af49` |
| R2 | 2026-07-20 | Set up job | 94.0s | 33.5s | 181% | [#239](https://github.com/githubnext/gh-aw-test/actions/runs/29716703808) | `7bdc455764` / `7bdc455764ae` |
| R3 | 2026-07-27 | Set up job | 46.0s | 28.0s | 64% | [#266](https://github.com/githubnext/gh-aw-test/actions/runs/30271118206) | `55b5181bb8` / `55b5181bb855` |

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

## Run, job & step times (`released`, using samples)

**92 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for released, using samples](timing-released-samples.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 92 | 115.5s | 160.9s |
| Workflow start to proxy step | 92 | 61.0s | 92.9s |
| Proxy step to first reasoning/sample | 92 | 0.0s | 1.0s |
| Job `activation` | 92 | 16.5s | 35.6s |
| Job `agent` | 92 | 39.5s | 50.7s |
| Job `detection` | 0 | n/a | n/a |
| Job `safe_outputs` | 92 | 12.0s | 19.9s |
| Job `conclusion` | 92 | 16.0s | 20.9s |
| Major step `Install ripgrep` | 2 | 17.5s | 23.5s |
| Major step `Download container images` | 92 | 9.0s | 14.9s |
| Major step `Start MCP Gateway` | 92 | 7.0s | 12.0s |
| Major step `Install GitHub Copilot CLI` | 92 | 4.0s | 5.0s |
| Major step `Set up job` | 79 | 2.0s | 5.0s |
| Major step `Setup Scripts` | 81 | 2.0s | 4.0s |
| Major step `Install AWF binary` | 7 | 2.0s | 2.4s |
| Major step `Download activation artifact` | 31 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 21 | 2.0s | 2.0s |
| Major step `Stop MCP Gateway` | 10 | 2.0s | 2.0s |
| Major step `Checkout repository` | 3 | 2.0s | 2.0s |

### Major step times for job `activation` (`released`, using samples)

![Major step times for activation, released, using samples](steps-activation-released-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-07-18 to 2026-07-20 | Setup Scripts | 33.0s | 2.0s | 1550% | [#241](https://github.com/githubnext/gh-aw-test/actions/runs/29718236306) | `v0.82.13` / `017cdbc1b474` |
| R2 | 2026-07-23 to 2026-07-27 | Set up job | 21.0s | 3.0s | 600% | [#264](https://github.com/githubnext/gh-aw-test/actions/runs/30253250421) | `v0.83.4` / `bbb804287845` |
| R3 | 2026-07-25 | Setup Scripts | 18.0s | 2.5s | 620% | [#268](https://github.com/githubnext/gh-aw-test/actions/runs/30329600083) | `v0.83.3` / `7e728ffd6fc9` |

### Major step times for job `agent` (`released`, using samples)

![Major step times for agent, released, using samples](steps-agent-released-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-07-16 | Set up job | 32.0s | 2.0s | 1500% | [#232](https://github.com/githubnext/gh-aw-test/actions/runs/29555946105) | `v0.82.11` / `38e22c4075e3` |
| R2 | 2026-07-24 to 2026-07-25 | Download container images | 24.0s | 8.0s | 200% | [#263](https://github.com/githubnext/gh-aw-test/actions/runs/30238750701) | `v0.83.3` / `7e728ffd6fc9` |
| R3 | 2026-07-27 | Set up job | 28.0s | 3.0s | 833% | [#269](https://github.com/githubnext/gh-aw-test/actions/runs/30330754586) | `v0.83.4` / `bbb804287845` |
| R4 | 2026-08-11 | Download container images | 27.0s | 12.0s | 125% | [#398](https://github.com/githubnext/gh-aw-test/actions/runs/32617180095) | `v0.86.2` / `48e5fa3ff522` |
| R5 | 2026-08-11 | Install GitHub Copilot CLI | 15.0s | 4.0s | 275% | [#398](https://github.com/githubnext/gh-aw-test/actions/runs/32617180095) | `v0.86.2` / `48e5fa3ff522` |
| R6 | 2026-08-22 | Install GitHub Copilot CLI | 20.0s | 4.5s | 344% | [#399](https://github.com/githubnext/gh-aw-test/actions/runs/32618677146) | `v0.87.4` / `83d6315352f7` |

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

### Major step times for job `conclusion` (`released`, using samples)

![Major step times for conclusion, released, using samples](steps-conclusion-released-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-07-23 | Set up job | 23.0s | 3.0s | 667% | [#251](https://github.com/githubnext/gh-aw-test/actions/runs/30006117618) | `v0.83.1` / `6268b9870d9f` |
| R2 | 2026-07-27 | Set up job | 16.0s | 2.5s | 540% | [#264](https://github.com/githubnext/gh-aw-test/actions/runs/30253250421) | `v0.83.4` / `bbb804287845` |

## Method

Each section fixes both independent dimensions: gh-aw source (`main` or combined stable/pre-release `released`) and execution mode (`inference` or `samples`). Only overall-successful `workflow_dispatch` runs with a successful `agent` job are included. Candidate regression baselines use up to ten preceding observations from the same section and step; displayed regression episodes are limited to the six weeks before report generation. A step is graphed when it has a sustained cost, recent slowdown, or recent regression. Runs with missing compiler metadata remain in CSV/JSON but are excluded from graphs.
