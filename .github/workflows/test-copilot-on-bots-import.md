---
on:
  workflow_dispatch:
  issues:
    types: [opened]
  skip-bots: ["github-actions[bot]"]
imports:
  - shared/phase3-bots.md
permissions:
  contents: read
  issues: read
engine: copilot
safe-outputs:
  create-issue:
    samples:
      - title: "Imported bot allowlist passed"
        body: "Imported and local bot allowlists were merged."
---

Create one issue confirming the imported and local bot skip lists compiled.