---
on:
  workflow_dispatch:

permissions:
  issues: read
  pull-requests: read
  actions: read
  contents: read
  discussions: read
  copilot-requests: write

engine: 
  id: copilot

safe-outputs:
  noop:
    # min: 1
    samples:
      - message: "noop safe output from Copilot"
---

Emit a `noop` safe output with the message "noop safe output from Copilot" to demonstrate the no-op safe output path.
