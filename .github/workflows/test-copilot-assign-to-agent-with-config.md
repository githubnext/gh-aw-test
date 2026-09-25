---
on:
  workflow_dispatch:
permissions:
  issues: read
  contents: read
  copilot-requests: write
engine: copilot
safe-outputs:
  create-issue:
    title-prefix: "[copilot-test] "
    labels: [copilot, automation]
    samples:
      - temporary_id: aw_config
        title: "Test configured assign-to-agent"
        body: "Assignment fixture for optional agent configuration."
  assign-to-agent:
    target: "*"
    allowed: [copilot]
    name: copilot
    model: auto
    base-branch: main
    custom-instructions: "Only inspect the fixture issue; do not modify repository files."
    ignore-if-error: true
    samples:
      - issue_number: "#aw_config"
---

Create the fixture issue with temporary ID `aw_config`, then assign Copilot using all configured optional fields.