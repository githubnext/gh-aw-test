---
on:
  workflow_dispatch:
imports:
  - shared/phase3-nested-parent.md
permissions:
  contents: read
  issues: read
engine: copilot
steps:
  - name: Append main marker
    run: echo -n A >> /tmp/gh-aw/import-order.txt
safe-outputs:
  create-issue:
    samples:
      - title: "Nested import order passed"
        body: "Observed dependency order: CBA"
---

Read `/tmp/gh-aw/import-order.txt` and create one issue reporting the exact
marker order. The expected dependency order is `CBA`.