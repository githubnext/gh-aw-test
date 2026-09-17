---
on:
  workflow_dispatch:
  workflow_run:
    workflows: ["Nightly E2E Tests"]
    types: [completed]
    branches: [main]
    conclusion: success
permissions:
  contents: read
  actions: read
  issues: read
engine: copilot
safe-outputs:
  create-issue:
    samples:
      - title: "Workflow-run conclusion filter passed"
        body: "The success conclusion filter compiled and the dispatch path ran."
---

Create one issue confirming the workflow-run conclusion filter compiled.