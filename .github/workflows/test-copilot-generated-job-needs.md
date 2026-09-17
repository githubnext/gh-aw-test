---
on:
  workflow_dispatch:
permissions:
  contents: read
  issues: read
engine: copilot
jobs:
  prepare:
    runs-on: ubuntu-latest
    steps:
      - run: echo "prepare dependency completed"
  agent:
    needs: [prepare]
safe-outputs:
  create-issue:
    samples:
      - title: "Generated agent job needs passed"
        body: "The prepare dependency completed before the generated agent job."
---

Create one issue confirming that the custom prepare dependency completed before
the generated agent job.