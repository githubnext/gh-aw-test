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
  create-issue:
    title-prefix: "[custom-engine] "
    samples:
      - title: Declarative engine passed
        body: Imported engine behaviors completed successfully.
---

Create one issue titled `Declarative engine passed` with body `Imported engine behaviors completed successfully.`