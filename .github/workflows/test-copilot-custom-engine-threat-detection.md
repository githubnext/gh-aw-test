---
on:
  workflow_dispatch:
permissions:
  contents: read
  issues: read
  copilot-requests: write
imports:
  - github/gh-aw/.github/workflows/shared/opencode.md@ca470ff0726a579fd2663f09c72700727f80124d
engine:
  id: opencode
model: copilot/auto
safe-outputs:
  threat-detection:
    engine: copilot
  create-issue:
    title-prefix: "[custom-engine-detection] "
    samples:
      - title: Custom engine detection passed
        body: Copilot threat detection completed for a custom engine.
---

Create one issue titled `Custom engine detection passed` with body `Copilot threat detection completed for a custom engine.`