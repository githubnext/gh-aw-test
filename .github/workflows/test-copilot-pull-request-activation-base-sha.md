---
on:
  pull_request:
    types: [synchronize]
permissions:
  contents: read
  issues: read
  pull-requests: read
  copilot-requests: write
engine:
  id: copilot
safe-outputs:
  add-comment:
    target: triggering
    samples:
      - body: GH_AW_ACTIVATION_BASE_SENTINEL
---

{{#runtime-import shared/phase-c-activation-sentinel.md}}

Add a comment to the triggering pull request containing exactly the sentinel from the imported file.