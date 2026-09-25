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
      - temporary_id: aw_effort
        title: "Test assign-to-agent reasoning effort"
        body: "Assignment fixture for reasoning-effort propagation."
  assign-to-agent:
    target: "*"
    allowed: [copilot]
    name: copilot
    reasoning-effort: high
    ignore-if-error: true
    samples:
      - issue_number: "#aw_effort"
---

Create the fixture issue with temporary ID `aw_effort`, then assign Copilot to it using the configured reasoning effort.