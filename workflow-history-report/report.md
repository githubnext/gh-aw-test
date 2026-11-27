# Performance history for `copilot-create-issue.md`

## Run, job & step times (`main`, using inference)

**155 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for main, using inference](timing-main-inference.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 155 | 364.0s | 450.6s |
| Workflow start to proxy step | 155 | 118.0s | 155.0s |
| Proxy step to first reasoning/sample | 147 | 23.1s | 35.9s |
| Copilot phase — AWF startup | 147 | 15.2s | 21.4s |
| Copilot phase — harness startup | 147 | 2.7s | 8.9s |
| Copilot phase — Copilot process | 147 | 6.5s | 11.5s |
| Job `activation` | 155 | 50.0s | 73.6s |
| Job `agent` | 155 | 92.0s | 166.2s |
| Job `detection` | 155 | 78.0s | 104.6s |
| Job `safe_outputs` | 155 | 44.0s | 73.2s |
| Job `conclusion` | 155 | 48.0s | 68.0s |
| Major step `Execute GitHub Copilot CLI` | 155 | 30.0s | 111.0s |
| Major step `Set up job` | 155 | 19.0s | 23.6s |
| Major step `Install ripgrep` | 6 | 14.0s | 19.0s |
| Major step `Download container images` | 155 | 11.0s | 18.0s |
| Major step `Start MCP Gateway` | 155 | 7.0s | 13.0s |
| Major step `Install AWF binary` | 28 | 6.5s | 13.3s |
| Major step `Install GitHub Copilot CLI` | 155 | 5.0s | 13.0s |
| Major step `Setup Scripts` | 154 | 3.0s | 7.0s |
| Major step `Download activation artifact` | 60 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 45 | 2.0s | 2.0s |
| Major step `Checkout repository` | 27 | 2.0s | 3.0s |
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
| R2 | 2026-11-22 | Set up job | 55.0s | 34.0s | 62% | [#800](https://github.com/githubnext/gh-aw-test/actions/runs/44979646918) | `b2e5b37a25` / `b2e5b37a259e` |

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
| R9 | 2026-11-15 | Copilot phase — Copilot process | 18.4s | 6.8s | 170% | [#772](https://github.com/githubnext/gh-aw-test/actions/runs/43671351291) | `48d1b1b714` / `48d1b1b7142d` |
| R10 | 2026-11-16 | Install GitHub Copilot CLI | 32.0s | 8.5s | 276% | [#776](https://github.com/githubnext/gh-aw-test/actions/runs/43796809330) | `71063c8b95` / `71063c8b9540` |
| R11 | 2026-11-18 | Download container images | 59.0s | 12.5s | 372% | [#784](https://github.com/githubnext/gh-aw-test/actions/runs/44228972036) | `74f66c64ff` / `74f66c64fff4` |
| R12 | 2026-11-27 | Install GitHub Copilot CLI | 22.0s | 10.0s | 120% | [#812](https://github.com/githubnext/gh-aw-test/actions/runs/45932805668) | `ca7ccb770f` / `ca7ccb770ff7` |

### Major step times for job `detection` (`main`, using inference)

![Major step times for detection, main, using inference](steps-detection-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-10-22 | Install GitHub Copilot CLI | 24.0s | 7.5s | 220% | [#679](https://github.com/githubnext/gh-aw-test/actions/runs/39715911390) | `2b01e8ed2a` / `2b01e8ed2a27` |
| R2 | 2026-11-02 to 2026-11-07 | Install AWF binary | 14.0s | 1.0s | 1300% | [#742](https://github.com/githubnext/gh-aw-test/actions/runs/42333287253) | `0379ea63fb` / `0379ea63fbd7` |
| R3 | 2026-11-17 | Download container images | 21.0s | 9.0s | 133% | [#780](https://github.com/githubnext/gh-aw-test/actions/runs/44008657661) | `6a47c8553d` / `6a47c8553d4e` |

### Major step times for job `safe_outputs` (`main`, using inference)

![Major step times for safe_outputs, main, using inference](steps-safe-outputs-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-10-28 | Set up job | 57.0s | 33.5s | 70% | [#711](https://github.com/githubnext/gh-aw-test/actions/runs/40810886681) | `0bb0365790` / `0bb036579091` |
| R2 | 2026-11-02 | Set up job | 72.0s | 36.0s | 100% | [#727](https://github.com/githubnext/gh-aw-test/actions/runs/41381991056) | `110ad53df6` / `110ad53df63c` |
| R3 | 2026-11-05 | Set up job | 62.0s | 35.0s | 77% | [#738](https://github.com/githubnext/gh-aw-test/actions/runs/42155182196) | `f7b1cc2c3a` / `f7b1cc2c3a7a` |
| R4 | 2026-11-10 to 2026-11-12 | Set up job | 58.0s | 37.5s | 55% | [#762](https://github.com/githubnext/gh-aw-test/actions/runs/43146776510) | `1da86bb379` / `1da86bb37966` |

### Major step times for job `conclusion` (`main`, using inference)

![Major step times for conclusion, main, using inference](steps-conclusion-main-inference.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-10-22 | Set up job | 54.0s | 32.5s | 66% | [#679](https://github.com/githubnext/gh-aw-test/actions/runs/39715911390) | `2b01e8ed2a` / `2b01e8ed2a27` |
| R2 | 2026-11-13 | Set up job | 70.0s | 37.5s | 87% | [#766](https://github.com/githubnext/gh-aw-test/actions/runs/43357457586) | `5b6d021250` / `5b6d021250c8` |
| R3 | 2026-11-17 | Generate usage activity summary and unified session | 16.0s | 1.0s | 1500% | [#780](https://github.com/githubnext/gh-aw-test/actions/runs/44008657661) | `6a47c8553d` / `6a47c8553d4e` |
| R4 | 2026-11-17 | Set up job | 113.0s | 38.0s | 197% | [#780](https://github.com/githubnext/gh-aw-test/actions/runs/44008657661) | `6a47c8553d` / `6a47c8553d4e` |
| R5 | 2026-11-17 | Setup Scripts | 46.0s | 5.5s | 736% | [#780](https://github.com/githubnext/gh-aw-test/actions/runs/44008657661) | `6a47c8553d` / `6a47c8553d4e` |
| R6 | 2026-11-27 | Set up job | 67.0s | 38.0s | 76% | [#812](https://github.com/githubnext/gh-aw-test/actions/runs/45932805668) | `ca7ccb770f` / `ca7ccb770ff7` |

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

**147 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for main, using samples](timing-main-samples.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 147 | 217.0s | 272.6s |
| Workflow start to proxy step | 147 | 106.0s | 141.4s |
| Proxy step to first reasoning/sample | 147 | 0.0s | 1.0s |
| Job `activation` | 147 | 48.0s | 73.0s |
| Job `agent` | 147 | 53.0s | 73.8s |
| Job `detection` | 0 | n/a | n/a |
| Job `safe_outputs` | 147 | 37.0s | 59.6s |
| Job `conclusion` | 147 | 40.0s | 65.4s |
| Major step `Install AWF binary` | 20 | 12.0s | 14.1s |
| Major step `Download container images` | 147 | 10.0s | 15.0s |
| Major step `Set up job` | 147 | 9.0s | 15.4s |
| Major step `Start MCP Gateway` | 147 | 7.0s | 12.0s |
| Major step `Print firewall logs` | 1 | 5.0s | 5.0s |
| Major step `Install GitHub Copilot CLI` | 147 | 4.0s | 12.0s |
| Major step `Setup Scripts` | 146 | 3.0s | 7.0s |
| Major step `Checkout repository` | 26 | 2.0s | 3.0s |
| Major step `Download activation artifact` | 52 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 31 | 2.0s | 2.0s |
| Major step `Stop MCP Gateway` | 22 | 2.0s | 2.0s |
| Major step `Upload agent output fallback artifact` | 13 | 2.0s | 2.0s |
| Major step `Checkout repository (gh-aw default)` | 11 | 2.0s | 2.0s |

### Major step times for job `activation` (`main`, using samples)

![Major step times for activation, main, using samples](steps-activation-main-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-10-20 | Set up job | 62.0s | 34.0s | 82% | [#671](https://github.com/githubnext/gh-aw-test/actions/runs/39365173077) | `7363a87ff2` / `7363a87ff248` |
| R2 | 2026-11-02 | Setup Scripts | 22.0s | 6.0s | 267% | [#728](https://github.com/githubnext/gh-aw-test/actions/runs/41383278858) | `110ad53df6` / `110ad53df63c` |
| R3 | 2026-11-12 | Set up job | 48.0s | 32.0s | 50% | [#763](https://github.com/githubnext/gh-aw-test/actions/runs/43148421848) | `gh-aw/work-queue/1da86bb3796665d53d457cff14e06862fdf448f2` / `1da86bb37966` |
| R4 | 2026-11-27 | Set up job | 52.0s | 33.0s | 58% | [#813](https://github.com/githubnext/gh-aw-test/actions/runs/45934357313) | `ca7ccb770f` / `ca7ccb770ff7` |

### Major step times for job `agent` (`main`, using samples)

![Major step times for agent, main, using samples](steps-agent-main-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-10-20 | Download container images | 27.0s | 11.0s | 145% | [#671](https://github.com/githubnext/gh-aw-test/actions/runs/39365173077) | `7363a87ff2` / `7363a87ff248` |
| R2 | 2026-10-20 | Set up job | 21.0s | 11.0s | 91% | [#671](https://github.com/githubnext/gh-aw-test/actions/runs/39365173077) | `7363a87ff2` / `7363a87ff248` |
| R3 | 2026-10-21 | Install GitHub Copilot CLI | 17.0s | 7.0s | 143% | [#675](https://github.com/githubnext/gh-aw-test/actions/runs/39538801637) | `15d31e5375` / `15d31e5375b6` |
| R4 | 2026-10-31 | Set up job | 19.0s | 9.0s | 111% | [#720](https://github.com/githubnext/gh-aw-test/actions/runs/41164565470) | `f5d4768eda` / `f5d4768eda57` |
| R5 | 2026-11-02 to 2026-11-07 | Install AWF binary | 13.0s | 1.0s | 1200% | [#739](https://github.com/githubnext/gh-aw-test/actions/runs/42156621046) | `f7b1cc2c3a` / `f7b1cc2c3a7a` |
| R6 | 2026-11-15 | Install GitHub Copilot CLI | 19.0s | 8.5s | 124% | [#773](https://github.com/githubnext/gh-aw-test/actions/runs/43672452393) | `gh-aw/work-queue/48d1b1b7142d1748885227a8ac3fe57e8ee36a0b` / `48d1b1b7142d` |
| R7 | 2026-11-15 to 2026-11-17 | Set up job | 26.0s | 10.5s | 148% | [#781](https://github.com/githubnext/gh-aw-test/actions/runs/44010553291) | `gh-aw/work-queue/6a47c8553d4e12ffb27e84b191fc2e3143ecf674` / `6a47c8553d4e` |
| R8 | 2026-11-19 | Install GitHub Copilot CLI | 22.0s | 11.0s | 100% | [#793](https://github.com/githubnext/gh-aw-test/actions/runs/44667594587) | `32398b3f20` / `32398b3f20e9` |
| R9 | 2026-11-21 to 2026-11-22 | Set up job | 22.0s | 11.0s | 100% | [#797](https://github.com/githubnext/gh-aw-test/actions/runs/44861094599) | `ea7f2616b4` / `ea7f2616b491` |
| R10 | 2026-11-26 | Install GitHub Copilot CLI | 23.0s | 11.0s | 109% | [#809](https://github.com/githubnext/gh-aw-test/actions/runs/45749106561) | `a1afaae8b8` / `a1afaae8b839` |
| R11 | 2026-11-26 | Set up job | 24.0s | 12.5s | 92% | [#809](https://github.com/githubnext/gh-aw-test/actions/runs/45749106561) | `a1afaae8b8` / `a1afaae8b839` |

### Major step times for job `detection` (`main`, using samples)

![Major step times for detection, main, using samples](steps-detection-main-samples.svg)

#### Candidate regressions (last six weeks)

No candidate regressions in the last six weeks.

### Major step times for job `safe_outputs` (`main`, using samples)

![Major step times for safe_outputs, main, using samples](steps-safe-outputs-main-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-10-27 to 2026-10-28 | Set up job | 78.0s | 26.5s | 194% | [#704](https://github.com/githubnext/gh-aw-test/actions/runs/40444485731) | `6c387d00c7` / `6c387d00c750` |
| R2 | 2026-11-05 | Set up job | 59.0s | 31.5s | 87% | [#735](https://github.com/githubnext/gh-aw-test/actions/runs/41961481939) | `0aa2738ed8` / `0aa2738ed88d` |
| R3 | 2026-11-13 | Set up job | 109.0s | 31.0s | 252% | [#767](https://github.com/githubnext/gh-aw-test/actions/runs/43359061542) | `gh-aw/work-queue/849297657187eba1d1bd7a1c9441ae74050c475a` / `849297657187` |
| R4 | 2026-11-16 | Set up job | 49.0s | 31.0s | 58% | [#777](https://github.com/githubnext/gh-aw-test/actions/runs/43798388335) | `dca7c332c6` / `dca7c332c63e` |
| R5 | 2026-11-19 | Set up job | 52.0s | 31.0s | 68% | [#793](https://github.com/githubnext/gh-aw-test/actions/runs/44667594587) | `32398b3f20` / `32398b3f20e9` |

### Major step times for job `conclusion` (`main`, using samples)

![Major step times for conclusion, main, using samples](steps-conclusion-main-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-10-27 to 2026-10-30 | Set up job | 88.0s | 24.5s | 259% | [#716](https://github.com/githubnext/gh-aw-test/actions/runs/40997496546) | `0c48a3354d` / `0c48a3354d11` |
| R2 | 2026-11-02 to 2026-11-03 | Set up job | 54.0s | 25.5s | 112% | [#728](https://github.com/githubnext/gh-aw-test/actions/runs/41383278858) | `110ad53df6` / `110ad53df63c` |
| R3 | 2026-11-03 | Setup Scripts | 21.0s | 5.0s | 320% | [#731](https://github.com/githubnext/gh-aw-test/actions/runs/41571985205) | `b5b1bf7df7` / `b5b1bf7df754` |
| R4 | 2026-11-18 | Set up job | 43.0s | 23.0s | 87% | [#785](https://github.com/githubnext/gh-aw-test/actions/runs/44230541962) | `gh-aw/work-queue/74f66c64fff49802e66fbf25583d09e2d6b5f69b` / `74f66c64fff4` |

## Run, job & step times (`released`, using samples)

**273 successful runs.** Regressions shown below are limited to the last six weeks.

![Run and job times for released, using samples](timing-released-samples.svg)

| Run or job | Samples | Median | P90 |
|---|---:|---:|---:|
| Workflow complete | 273 | 127.0s | 169.0s |
| Workflow start to proxy step | 273 | 70.0s | 97.0s |
| Proxy step to first reasoning/sample | 273 | 0.0s | 1.0s |
| Job `activation` | 273 | 18.0s | 35.0s |
| Job `agent` | 273 | 45.0s | 65.8s |
| Job `detection` | 0 | n/a | n/a |
| Job `safe_outputs` | 273 | 13.0s | 22.0s |
| Job `conclusion` | 273 | 17.0s | 26.0s |
| Major step `Install AWF binary` | 46 | 11.0s | 14.0s |
| Major step `Download container images` | 273 | 10.0s | 18.0s |
| Major step `Install ripgrep` | 8 | 9.0s | 18.0s |
| Major step `Start MCP Gateway` | 273 | 7.0s | 12.8s |
| Major step `Install GitHub Copilot CLI` | 271 | 5.0s | 14.0s |
| Major step `Set up job` | 232 | 3.0s | 4.0s |
| Major step `Setup Scripts` | 259 | 2.0s | 5.0s |
| Major step `Download activation artifact` | 95 | 2.0s | 2.0s |
| Major step `Upload agent artifacts` | 56 | 2.0s | 2.0s |
| Major step `Stop MCP Gateway` | 31 | 2.0s | 2.0s |
| Major step `Checkout repository` | 33 | 2.0s | 3.0s |
| Major step `Upload agent output fallback artifact` | 22 | 2.0s | 2.0s |
| Major step `Checkout repository (gh-aw default)` | 6 | 2.0s | 2.0s |
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
| R1 | 2026-10-17 | Download container images | 27.0s | 10.5s | 157% | [#669](https://github.com/githubnext/gh-aw-test/actions/runs/39203708774) | `v0.92.5` / `cbc32699c3d6` |
| R2 | 2026-10-17 | Start MCP Gateway | 32.0s | 6.0s | 433% | [#673](https://github.com/githubnext/gh-aw-test/actions/runs/39375395453) | `v0.92.5` / `cbc32699c3d6` |
| R3 | 2026-10-22 | Download container images | 26.0s | 16.0s | 62% | [#701](https://github.com/githubnext/gh-aw-test/actions/runs/40269048729) | `v0.93.1` / `310317364125` |
| R4 | 2026-10-23 | Set up job | 13.0s | 2.0s | 550% | [#692](https://github.com/githubnext/gh-aw-test/actions/runs/40058412852) | `v0.93.3` / `317d9005a6bc` |
| R5 | 2026-10-25 to 2026-10-27 | Install GitHub Copilot CLI | 19.0s | 3.0s | 533% | [#709](https://github.com/githubnext/gh-aw-test/actions/runs/40631906382) | `v0.93.5` / `32ecafbc061c` |
| R6 | 2026-10-25 | Start MCP Gateway | 15.0s | 5.0s | 200% | [#709](https://github.com/githubnext/gh-aw-test/actions/runs/40631906382) | `v0.93.5` / `32ecafbc061c` |
| R7 | 2026-11-04 to 2026-11-06 | Install AWF binary | 14.0s | 1.0s | 1300% | [#737](https://github.com/githubnext/gh-aw-test/actions/runs/41973253286) | `v1.2.0` / `18928ba35b7e` |
| R8 | 2026-11-06 | Install GitHub Copilot CLI | 21.0s | 9.5s | 121% | [#768](https://github.com/githubnext/gh-aw-test/actions/runs/43365622315) | `v1.2.1` / `8f3224323bdf` |
| R9 | 2026-11-10 | Download container images | 14.0s | 4.0s | 250% | [#802](https://github.com/githubnext/gh-aw-test/actions/runs/44985678172) | `v1.2.2` / `399a445fe2d8` |
| R10 | 2026-11-10 to 2026-11-13 | Install GitHub Copilot CLI | 29.0s | 7.5s | 287% | [#771](https://github.com/githubnext/gh-aw-test/actions/runs/43553611003) | `v1.2.3` / `5b6d021250c8` |

### Major step times for job `detection` (`released`, using samples)

![Major step times for detection, released, using samples](steps-detection-released-samples.svg)

#### Candidate regressions (last six weeks)

No candidate regressions in the last six weeks.

### Major step times for job `safe_outputs` (`released`, using samples)

![Major step times for safe_outputs, released, using samples](steps-safe-outputs-released-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-10-23 | Set up job | 26.0s | 3.0s | 767% | [#692](https://github.com/githubnext/gh-aw-test/actions/runs/40058412852) | `v0.93.3` / `317d9005a6bc` |
| R2 | 2026-10-23 | Setup Scripts | 13.0s | 3.0s | 333% | [#692](https://github.com/githubnext/gh-aw-test/actions/runs/40058412852) | `v0.93.3` / `317d9005a6bc` |

### Major step times for job `conclusion` (`released`, using samples)

![Major step times for conclusion, released, using samples](steps-conclusion-released-samples.svg)

#### Candidate regressions (last six weeks)

| Label | Episode | Step | Peak | Prior median | Increase | Run | gh-aw version / commit |
|---|---|---|---:|---:|---:|---|---|
| R1 | 2026-10-22 to 2026-10-23 | Set up job | 29.0s | 3.0s | 867% | [#692](https://github.com/githubnext/gh-aw-test/actions/runs/40058412852) | `v0.93.3` / `317d9005a6bc` |
| R2 | 2026-10-22 | Setup Scripts | 15.0s | 3.0s | 400% | [#686](https://github.com/githubnext/gh-aw-test/actions/runs/39910702968) | `v0.93.1` / `310317364125` |

## Method

Each section fixes both independent dimensions: gh-aw source (`main` or combined stable/pre-release `released`) and execution mode (`inference` or `samples`). Only overall-successful `workflow_dispatch` runs with a successful `agent` job are included. Candidate regression baselines use up to ten preceding observations from the same section and step; displayed regression episodes are limited to the six weeks before report generation. A step is graphed when it has a sustained cost, recent slowdown, or recent regression. Runs with missing compiler metadata remain in CSV/JSON but are excluded from graphs.

For inference runs, `Execute GitHub Copilot CLI` is additionally split using timestamped runtime markers: **AWF startup** is step start to the AWF agent-container entrypoint, **harness startup** is that entrypoint to the first Copilot process start, and **Copilot process** is the first process start through the final process close (including retries and retry delays). Cleanup after process close remains visible only in the full step duration, while unavailable markers produce no phase value.
