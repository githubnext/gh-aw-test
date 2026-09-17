---
on:
  workflow_dispatch:
permissions:
  contents: read
  issues: read
engine: copilot
safe-outputs:
  create-issue:
    samples:
      - title: "aw.yml wildcard package passed"
        body: "The package manifest expanded both direct workflow children."
---

Create one issue confirming that the phase-3 package manifest fixture was
installed with both direct children from its trailing wildcard include.