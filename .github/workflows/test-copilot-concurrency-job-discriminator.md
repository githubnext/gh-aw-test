---
on:
  workflow_dispatch:
imports:
  - shared/phase3-discriminator.md
permissions:
  contents: read
  issues: read
engine: copilot
safe-outputs:
  create-issue:
    samples:
      - title: "Imported job discriminator passed"
        body: "The imported discriminator reached generated job concurrency groups."
---

Create one issue confirming the workflow ran with its imported job discriminator.