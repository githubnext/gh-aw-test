---
on:
  workflow_dispatch:
permissions:
  contents: read
  issues: read
engine: copilot
jobs:
  agent:
    continue-on-error: true
safe-outputs:
  create-issue:
    samples:
      - title: "Agent continue-on-error frontmatter passed"
        body: "The generated agent job retained continue-on-error."
---

Create one issue confirming the agent job ran with its explicit job settings.