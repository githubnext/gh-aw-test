# Performance history for `copilot-create-issue.md`

## Run, job & step times (`main`, using inference)

**144 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for main, using inference](timing-main-inference.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 144 | 358.0s | 440.4s |
| Workflow start to proxy step | 144 | 117.0s | 153.4s |
| Proxy step to first reasoning/sample | 136 | 22.2s | 32.0s |
| Copilot phase — AWF startup | 136 | 14.8s | 21.6s |
| Copilot phase — harness startup | 136 | 2.5s | 7.8s |
| Copilot phase — Copilot process | 136 | 6.3s | 9.4s |
| Job `activation` | 144 | 50.0s | 73.4s |
| Job `agent` | 144 | 91.5s | 164.7s |
| Job `detection` | 144 | 77.0s | 101.0s |
| Job `safe_outputs` | 144 | 44.0s | 73.4s |
| Job `conclusion` | 144 | 47.0s | 65.7s |
| Major step `Execute GitHub Copilot CLI` | 144 | 28.5s | 111.7s |
| Major step `Set up job` | 144 | 19.0s | 23.0s |
| Major step `Install ripgrep` | 6 | 14.0s | 19.0s |
| Major step `Download container images` | 144 | 11.0s | 18.0s |
| Major step `Start MCP Gateway` | 144 | 6.0s | 13.0s |
| Major step `Install GitHub Copilot CLI` | 144 | 4.0s | 12.7s |
| Major step `Setup Scripts` | 143 | 3.0s | 5.8s |
| Major step `Download activation artifact` | 56 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 40 | 2.0s | 2.0s |
| Major step `Checkout repository` | 27 | 2.0s | 3.0s |
| Major step `Install AWF binary` | 24 | 2.0s | 13.0s |
| Major step `Stop MCP Gateway` | 19 | 2.0s | 2.0s |
| Major step `Print firewall logs` | 2 | 2.0s | 2.0s |
| Major step `Audit pre-agent workspace` | 1 | 2.0s | 2.0s |
| Major step `Upload agent output fallback artifact` | 9 | 2.0s | 2.0s |
| Major step `Checkout repository (gh-aw default)` | 6 | 2.0s | 2.0s |
| Major step `Redact secrets in logs` | 2 | 2.0s | 2.0s |

### Major step times for job `activation` (`main`, using inference)

![Major step times for activation, main, using inference](steps-activation-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-11-08 | Set up job | 56.0s | 35.5s | 58% | [#746](https://github.com/githubnext/gh-aw-test/actions/runs/42441783222) | `2a5905e687` / `2a5905e6879a` |

### Major step times for job `agent` (`main`, using inference)

![Major step times for agent, main, using inference](steps-agent-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-10-16 to 2026-10-17 | Install GitHub Copilot CLI | 23.0s | 6.0s | 283% | [#658](https://github.com/githubnext/gh-aw-test/actions/runs/38997993206) | `d3915e4a21` / `d3915e4a2104` |
| R2 | 2026-10-17 | Copilot phase — AWF startup | 30.0s | 18.0s | 67% | [#658](https://github.com/githubnext/gh-aw-test/actions/runs/38997993206) | `d3915e4a21` / `d3915e4a2104` |
| R3 | 2026-10-25 | Download container images | 27.0s | 13.5s | 100% | [#695](https://github.com/githubnext/gh-aw-test/actions/runs/40157645986) | `2301a1bb74` / `2301a1bb74f2` |
| R4 | 2026-11-01 | Copilot phase — AWF startup | 29.4s | 18.9s | 56% | [#723](https://github.com/githubnext/gh-aw-test/actions/runs/41268861095) | `6cf066f682` / `6cf066f6821a` |
| R5 | 2026-11-01 | Execute GitHub Copilot CLI | 48.0s | 31.5s | 52% | [#723](https://github.com/githubnext/gh-aw-test/actions/runs/41268861095) | `6cf066f682` / `6cf066f6821a` |
| R6 | 2026-11-02 to 2026-11-07 | Install AWF binary | 13.0s | 1.0s | 1200% | [#727](https://github.com/githubnext/gh-aw-test/actions/runs/41381991056) | `110ad53df6` / `110ad53df63c` |
| R7 | 2026-11-05 | Install GitHub Copilot CLI | 29.0s | 3.0s | 867% | [#738](https://github.com/githubnext/gh-aw-test/actions/runs/42155182196) | `f7b1cc2c3a` / `f7b1cc2c3a7a` |
| R8 | 2026-11-09 | Install GitHub Copilot CLI | 20.0s | 3.0s | 567% | [#750](https://github.com/githubnext/gh-aw-test/actions/runs/42555382712) | `984d376779` / `984d37677904` |

### Major step times for job `detection` (`main`, using inference)

![Major step times for detection, main, using inference](steps-detection-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-10-03 | Install GitHub Copilot CLI | 26.0s | 8.0s | 225% | [#596](https://github.com/githubnext/gh-aw-test/actions/runs/37093124717) | `fe02b64412` / `fe02b644122e` |
| R2 | 2026-10-11 | Install GitHub Copilot CLI | 22.0s | 10.0s | 120% | [#627](https://github.com/githubnext/gh-aw-test/actions/runs/38108164405) | `a1376acf2e` / `a1376acf2ead` |
| R3 | 2026-10-22 | Install GitHub Copilot CLI | 24.0s | 7.5s | 220% | [#679](https://github.com/githubnext/gh-aw-test/actions/runs/39715911390) | `2b01e8ed2a` / `2b01e8ed2a27` |
| R4 | 2026-11-02 to 2026-11-07 | Install AWF binary | 14.0s | 1.0s | 1300% | [#742](https://github.com/githubnext/gh-aw-test/actions/runs/42333287253) | `0379ea63fb` / `0379ea63fbd7` |

### Major step times for job `safe_outputs` (`main`, using inference)

![Major step times for safe_outputs, main, using inference](steps-safe-outputs-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-10-09 | Set up job | 131.0s | 36.5s | 259% | [#619](https://github.com/githubnext/gh-aw-test/actions/runs/37878870672) | `c268866353` / `c2688663530a` |
| R2 | 2026-10-09 | Setup Scripts | 59.0s | 3.5s | 1586% | [#619](https://github.com/githubnext/gh-aw-test/actions/runs/37878870672) | `c268866353` / `c2688663530a` |
| R3 | 2026-10-15 | Set up job | 59.0s | 34.5s | 71% | [#649](https://github.com/githubnext/gh-aw-test/actions/runs/38685973796) | `5eb4c298ec` / `5eb4c298ecba` |
| R4 | 2026-10-28 | Set up job | 57.0s | 33.5s | 70% | [#711](https://github.com/githubnext/gh-aw-test/actions/runs/40810886681) | `0bb0365790` / `0bb036579091` |
| R5 | 2026-11-02 | Set up job | 72.0s | 36.0s | 100% | [#727](https://github.com/githubnext/gh-aw-test/actions/runs/41381991056) | `110ad53df6` / `110ad53df63c` |
| R6 | 2026-11-05 | Set up job | 62.0s | 35.0s | 77% | [#738](https://github.com/githubnext/gh-aw-test/actions/runs/42155182196) | `f7b1cc2c3a` / `f7b1cc2c3a7a` |
| R7 | 2026-11-10 to 2026-11-12 | Set up job | 58.0s | 37.5s | 55% | [#762](https://github.com/githubnext/gh-aw-test/actions/runs/43146776510) | `1da86bb379` / `1da86bb37966` |

### Major step times for job `conclusion` (`main`, using inference)

![Major step times for conclusion, main, using inference](steps-conclusion-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-10-04 | Set up job | 49.0s | 32.0s | 53% | [#599](https://github.com/githubnext/gh-aw-test/actions/runs/37176542463) | `054871a707` / `054871a7076b` |
| R2 | 2026-10-15 | Set up job | 78.0s | 32.5s | 140% | [#645](https://github.com/githubnext/gh-aw-test/actions/runs/38675409397) | `e7bc6056a7` / `e7bc6056a784` |
| R3 | 2026-10-22 | Set up job | 54.0s | 32.5s | 66% | [#679](https://github.com/githubnext/gh-aw-test/actions/runs/39715911390) | `2b01e8ed2a` / `2b01e8ed2a27` |
| R4 | 2026-11-13 | Set up job | 70.0s | 37.5s | 87% | [#766](https://github.com/githubnext/gh-aw-test/actions/runs/43357457586) | `5b6d021250` / `5b6d021250c8` |

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
| R1 | 2026-10-23 | Set up job | 31.0s | 3.0s | 933% | [#691](https://github.com/githubnext/gh-aw-test/actions/runs/40057619697) | `v0.93.3` / `317d9005a6bc` |

### Major step times for job `agent` (`released`, using inference)

![Major step times for agent, released, using inference](steps-agent-released-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-10-23 | Set up job | 20.0s | 3.0s | 567% | [#691](https://github.com/githubnext/gh-aw-test/actions/runs/40057619697) | `v0.93.3` / `317d9005a6bc` |

### Major step times for job `detection` (`released`, using inference)

![Major step times for detection, released, using inference](steps-detection-released-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-10-23 | Set up job | 25.0s | 2.5s | 900% | [#691](https://github.com/githubnext/gh-aw-test/actions/runs/40057619697) | `v0.93.3` / `317d9005a6bc` |

### Major step times for job `safe_outputs` (`released`, using inference)

![Major step times for safe_outputs, released, using inference](steps-safe-outputs-released-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-10-23 | Set up job | 20.0s | 3.0s | 567% | [#691](https://github.com/githubnext/gh-aw-test/actions/runs/40057619697) | `v0.93.3` / `317d9005a6bc` |

### Major step times for job `conclusion` (`released`, using inference)

![Major step times for conclusion, released, using inference](steps-conclusion-released-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-10-23 | Set up job | 35.0s | 3.0s | 1067% | [#691](https://github.com/githubnext/gh-aw-test/actions/runs/40057619697) | `v0.93.3` / `317d9005a6bc` |

## Run, job & step times (`main`, using samples)

**137 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for main, using samples](timing-main-samples.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 137 | 212.0s | 274.2s |
| Workflow start to proxy step | 137 | 104.0s | 134.4s |
| Proxy step to first reasoning/sample | 137 | 0.0s | 1.0s |
| Job `activation` | 137 | 48.0s | 73.0s |
| Job `agent` | 137 | 52.0s | 69.0s |
| Job `detection` | 0 | n/a | n/a |
| Job `safe_outputs` | 137 | 36.0s | 58.0s |
| Job `conclusion` | 137 | 39.0s | 65.4s |
| Major step `Install AWF binary` | 17 | 12.0s | 13.0s |
| Major step `Download container images` | 137 | 10.0s | 15.0s |
| Major step `Set up job` | 137 | 9.0s | 14.4s |
| Major step `Start MCP Gateway` | 137 | 6.0s | 12.0s |
| Major step `Print firewall logs` | 1 | 5.0s | 5.0s |
| Major step `Install GitHub Copilot CLI` | 137 | 4.0s | 11.0s |
| Major step `Setup Scripts` | 136 | 3.0s | 6.5s |
| Major step `Checkout repository` | 26 | 2.0s | 3.0s |
| Major step `Download activation artifact` | 45 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 26 | 2.0s | 2.0s |
| Major step `Stop MCP Gateway` | 22 | 2.0s | 2.0s |
| Major step `Upload agent output fallback artifact` | 10 | 2.0s | 2.0s |
| Major step `Checkout repository (gh-aw default)` | 10 | 2.0s | 2.0s |

### Major step times for job `activation` (`main`, using samples)

![Major step times for activation, main, using samples](steps-activation-main-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-10-10 | Setup Scripts | 24.0s | 4.5s | 433% | [#624](https://github.com/githubnext/gh-aw-test/actions/runs/38020774086) | `6976a375a2` / `6976a375a288` |
| R2 | 2026-10-11 | Set up job | 86.0s | 32.0s | 169% | [#628](https://github.com/githubnext/gh-aw-test/actions/runs/38108788934) | `a1376acf2e` / `a1376acf2ead` |
| R3 | 2026-10-20 | Set up job | 62.0s | 34.0s | 82% | [#671](https://github.com/githubnext/gh-aw-test/actions/runs/39365173077) | `7363a87ff2` / `7363a87ff248` |
| R4 | 2026-11-02 | Setup Scripts | 22.0s | 6.0s | 267% | [#728](https://github.com/githubnext/gh-aw-test/actions/runs/41383278858) | `110ad53df6` / `110ad53df63c` |
| R5 | 2026-11-12 | Set up job | 48.0s | 32.0s | 50% | [#763](https://github.com/githubnext/gh-aw-test/actions/runs/43148421848) | `gh-aw/work-queue/1da86bb3796665d53d457cff14e06862fdf448f2` / `1da86bb37966` |

### Major step times for job `agent` (`main`, using samples)

![Major step times for agent, main, using samples](steps-agent-main-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-10-08 | Set up job | 20.0s | 10.0s | 100% | [#616](https://github.com/githubnext/gh-aw-test/actions/runs/37723139085) | `23403d903f` / `23403d903f5c` |
| R2 | 2026-10-20 | Download container images | 27.0s | 11.0s | 145% | [#671](https://github.com/githubnext/gh-aw-test/actions/runs/39365173077) | `7363a87ff2` / `7363a87ff248` |
| R3 | 2026-10-20 | Set up job | 21.0s | 11.0s | 91% | [#671](https://github.com/githubnext/gh-aw-test/actions/runs/39365173077) | `7363a87ff2` / `7363a87ff248` |
| R4 | 2026-10-21 | Install GitHub Copilot CLI | 17.0s | 7.0s | 143% | [#675](https://github.com/githubnext/gh-aw-test/actions/runs/39538801637) | `15d31e5375` / `15d31e5375b6` |
| R5 | 2026-10-31 | Set up job | 19.0s | 9.0s | 111% | [#720](https://github.com/githubnext/gh-aw-test/actions/runs/41164565470) | `f5d4768eda` / `f5d4768eda57` |
| R6 | 2026-11-02 to 2026-11-07 | Install AWF binary | 13.0s | 1.0s | 1200% | [#739](https://github.com/githubnext/gh-aw-test/actions/runs/42156621046) | `f7b1cc2c3a` / `f7b1cc2c3a7a` |

### Major step times for job `detection` (`main`, using samples)

![Major step times for detection, main, using samples](steps-detection-main-samples.svg)

#### Candidate regressions (last six weeks)

No candidate regressions in the last six weeks.

### Major step times for job `safe_outputs` (`main`, using samples)

![Major step times for safe_outputs, main, using samples](steps-safe-outputs-main-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-10-15 | Set up job | 128.0s | 25.0s | 412% | [#650](https://github.com/githubnext/gh-aw-test/actions/runs/38687065162) | `5eb4c298ec` / `5eb4c298ecba` |
| R2 | 2026-10-15 | Setup Scripts | 33.0s | 5.0s | 560% | [#650](https://github.com/githubnext/gh-aw-test/actions/runs/38687065162) | `5eb4c298ec` / `5eb4c298ecba` |
| R3 | 2026-10-27 to 2026-10-28 | Set up job | 78.0s | 26.5s | 194% | [#704](https://github.com/githubnext/gh-aw-test/actions/runs/40444485731) | `6c387d00c7` / `6c387d00c750` |
| R4 | 2026-11-05 | Set up job | 59.0s | 31.5s | 87% | [#735](https://github.com/githubnext/gh-aw-test/actions/runs/41961481939) | `0aa2738ed8` / `0aa2738ed88d` |
| R5 | 2026-11-13 | Set up job | 109.0s | 31.0s | 252% | [#767](https://github.com/githubnext/gh-aw-test/actions/runs/43359061542) | `gh-aw/work-queue/849297657187eba1d1bd7a1c9441ae74050c475a` / `849297657187` |

### Major step times for job `conclusion` (`main`, using samples)

![Major step times for conclusion, main, using samples](steps-conclusion-main-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-10-04 | Set up job | 46.0s | 25.0s | 84% | [#604](https://github.com/githubnext/gh-aw-test/actions/runs/37259935923) | `a5e1584ee9` / `a5e1584ee9ac` |
| R2 | 2026-10-08 | Set up job | 44.0s | 25.5s | 73% | [#616](https://github.com/githubnext/gh-aw-test/actions/runs/37723139085) | `23403d903f` / `23403d903f5c` |
| R3 | 2026-10-14 to 2026-10-15 | Set up job | 44.0s | 26.0s | 69% | [#640](https://github.com/githubnext/gh-aw-test/actions/runs/38506297635) | `d06e0878f2` / `d06e0878f2b7` |
| R4 | 2026-10-27 to 2026-10-30 | Set up job | 88.0s | 24.5s | 259% | [#716](https://github.com/githubnext/gh-aw-test/actions/runs/40997496546) | `0c48a3354d` / `0c48a3354d11` |
| R5 | 2026-11-02 to 2026-11-03 | Set up job | 54.0s | 25.5s | 112% | [#728](https://github.com/githubnext/gh-aw-test/actions/runs/41383278858) | `110ad53df6` / `110ad53df63c` |
| R6 | 2026-11-03 | Setup Scripts | 21.0s | 5.0s | 320% | [#731](https://github.com/githubnext/gh-aw-test/actions/runs/41571985205) | `b5b1bf7df7` / `b5b1bf7df754` |

## Run, job & step times (`released`, using samples)

**249 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for released, using samples](timing-released-samples.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 249 | 126.0s | 169.4s |
| Workflow start to proxy step | 249 | 69.0s | 96.2s |
| Proxy step to first reasoning/sample | 249 | 0.0s | 1.0s |
| Job `activation` | 249 | 18.0s | 35.2s |
| Job `agent` | 249 | 44.0s | 63.0s |
| Job `detection` | 0 | n/a | n/a |
| Job `safe_outputs` | 249 | 13.0s | 23.0s |
| Job `conclusion` | 249 | 16.0s | 26.2s |
| Major step `Download container images` | 249 | 10.0s | 19.0s |
| Major step `Install ripgrep` | 8 | 9.0s | 18.0s |
| Major step `Start MCP Gateway` | 249 | 7.0s | 12.0s |
| Major step `Install GitHub Copilot CLI` | 247 | 4.0s | 12.4s |
| Major step `Set up job` | 210 | 3.0s | 4.0s |
| Major step `Setup Scripts` | 235 | 2.0s | 5.0s |
| Major step `Install AWF binary` | 29 | 2.0s | 12.2s |
| Major step `Download activation artifact` | 86 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 52 | 2.0s | 2.0s |
| Major step `Stop MCP Gateway` | 28 | 2.0s | 2.0s |
| Major step `Checkout repository` | 33 | 2.0s | 3.0s |
| Major step `Upload agent output fallback artifact` | 15 | 2.0s | 2.0s |
| Major step `Checkout repository (gh-aw default)` | 5 | 2.0s | 2.0s |
| Major step `Redact secrets in logs` | 2 | 2.0s | 2.0s |

### Major step times for job `activation` (`released`, using samples)

![Major step times for activation, released, using samples](steps-activation-released-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-10-23 | Set up job | 33.0s | 2.5s | 1220% | [#692](https://github.com/githubnext/gh-aw-test/actions/runs/40058412852) | `v0.93.3` / `317d9005a6bc` |
| R2 | 2026-10-27 | Setup Scripts | 14.0s | 4.0s | 250% | [#722](https://github.com/githubnext/gh-aw-test/actions/runs/41172355892) | `v1.0.1` / `0627fdbe4beb` |
| R3 | 2026-11-06 | Set up job | 12.0s | 2.0s | 500% | [#764](https://github.com/githubnext/gh-aw-test/actions/runs/43155448184) | `v1.2.1` / `8f3224323bdf` |

### Major step times for job `agent` (`released`, using samples)

![Major step times for agent, released, using samples](steps-agent-released-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-10-14 | Install GitHub Copilot CLI | 21.0s | 7.0s | 200% | [#648](https://github.com/githubnext/gh-aw-test/actions/runs/38683926531) | `v0.91.14` / `667d4531279b` |
| R2 | 2026-10-14 | Start MCP Gateway | 20.0s | 6.0s | 233% | [#651](https://github.com/githubnext/gh-aw-test/actions/runs/38692101200) | `v0.91.12` / `5708fc68e91f` |
| R3 | 2026-10-17 | Download container images | 27.0s | 10.5s | 157% | [#669](https://github.com/githubnext/gh-aw-test/actions/runs/39203708774) | `v0.92.5` / `cbc32699c3d6` |
| R4 | 2026-10-17 | Start MCP Gateway | 32.0s | 6.0s | 433% | [#673](https://github.com/githubnext/gh-aw-test/actions/runs/39375395453) | `v0.92.5` / `cbc32699c3d6` |
| R5 | 2026-10-22 | Download container images | 26.0s | 16.0s | 62% | [#701](https://github.com/githubnext/gh-aw-test/actions/runs/40269048729) | `v0.93.1` / `310317364125` |
| R6 | 2026-10-23 | Set up job | 13.0s | 2.0s | 550% | [#692](https://github.com/githubnext/gh-aw-test/actions/runs/40058412852) | `v0.93.3` / `317d9005a6bc` |
| R7 | 2026-10-25 to 2026-10-27 | Install GitHub Copilot CLI | 19.0s | 3.0s | 533% | [#709](https://github.com/githubnext/gh-aw-test/actions/runs/40631906382) | `v0.93.5` / `32ecafbc061c` |
| R8 | 2026-10-25 | Start MCP Gateway | 15.0s | 5.0s | 200% | [#709](https://github.com/githubnext/gh-aw-test/actions/runs/40631906382) | `v0.93.5` / `32ecafbc061c` |
| R9 | 2026-11-04 to 2026-11-06 | Install AWF binary | 14.0s | 1.0s | 1300% | [#737](https://github.com/githubnext/gh-aw-test/actions/runs/41973253286) | `v1.2.0` / `18928ba35b7e` |
| R10 | 2026-11-06 | Install GitHub Copilot CLI | 21.0s | 9.5s | 121% | [#768](https://github.com/githubnext/gh-aw-test/actions/runs/43365622315) | `v1.2.1` / `8f3224323bdf` |

### Major step times for job `detection` (`released`, using samples)

![Major step times for detection, released, using samples](steps-detection-released-samples.svg)

#### Candidate regressions (last six weeks)

No candidate regressions in the last six weeks.

### Major step times for job `safe_outputs` (`released`, using samples)

![Major step times for safe_outputs, released, using samples](steps-safe-outputs-released-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-10-05 | Setup Scripts | 38.0s | 2.0s | 1800% | [#610](https://github.com/githubnext/gh-aw-test/actions/runs/37417069047) | `v0.91.0` / `af1e2fd1ef1e` |
| R2 | 2026-10-15 | Setup Scripts | 18.0s | 4.0s | 350% | [#672](https://github.com/githubnext/gh-aw-test/actions/runs/39369618109) | `v0.92.0` / `a68f5a9436d2` |
| R3 | 2026-10-23 | Set up job | 26.0s | 3.0s | 767% | [#692](https://github.com/githubnext/gh-aw-test/actions/runs/40058412852) | `v0.93.3` / `317d9005a6bc` |
| R4 | 2026-10-23 | Setup Scripts | 13.0s | 3.0s | 333% | [#692](https://github.com/githubnext/gh-aw-test/actions/runs/40058412852) | `v0.93.3` / `317d9005a6bc` |

### Major step times for job `conclusion` (`released`, using samples)

![Major step times for conclusion, released, using samples](steps-conclusion-released-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-10-05 | Setup Scripts | 13.0s | 2.0s | 550% | [#610](https://github.com/githubnext/gh-aw-test/actions/runs/37417069047) | `v0.91.0` / `af1e2fd1ef1e` |
| R2 | 2026-10-22 to 2026-10-23 | Set up job | 29.0s | 3.0s | 867% | [#692](https://github.com/githubnext/gh-aw-test/actions/runs/40058412852) | `v0.93.3` / `317d9005a6bc` |
| R3 | 2026-10-22 | Setup Scripts | 15.0s | 3.0s | 400% | [#686](https://github.com/githubnext/gh-aw-test/actions/runs/39910702968) | `v0.93.1` / `310317364125` |

## Method

Each section fixes both independent dimensions: gh-aw source (`main` or combined stable/pre-release `released`) and execution mode (`inference` or `samples`). Only overall-successful `workflow_dispatch` runs with a successful `agent` job are included. Candidate regression baselines use up to ten preceding observations from the same section and step; displayed regression episodes are limited to the six weeks before report generation. A step is graphed when it has a sustained cost, recent slowdown, or recent regression. Runs with missing compiler metadata remain in CSV/JSON but are excluded from graphs.

For inference runs, `Execute GitHub Copilot CLI` is additionally split using timestamped runtime markers: **AWF startup** is step start to the AWF agent-container entrypoint, **harness startup** is that entrypoint to the first Copilot process start, and **Copilot process** is the first process start through the final process close (including retries and retry delays). Cleanup after process close remains visible only in the full step duration, while unavailable markers produce no phase value.
