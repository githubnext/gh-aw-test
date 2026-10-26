---
on:
  pull_request_target:
    types: [opened]
    branches: [main]
    acknowledge-risk: true
    allowed-checkouts:
      - repository: github/github-mcp-server
        ref: main
permissions:
  contents: read
  issues: read
  pull-requests: read
  copilot-requests: write
engine:
  id: copilot
checkout:
  - repository: github/github-mcp-server
    ref: main
    path: external
    current: true
safe-outputs:
  create-issue:
    title-prefix: "[pull-request-target-checkout] "
    samples:
      - title: Allowed checkout passed
        body: The explicitly trusted external checkout completed.
---

Confirm that the external repository is checked out, then create one issue titled `Allowed checkout passed`.