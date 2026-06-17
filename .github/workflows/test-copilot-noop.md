---
on:
  workflow_dispatch:

permissions: read-all

engine: 
  id: copilot

safe-outputs:
  noop:
    # min: 1
    samples:
      - message: "noop safe output from Copilot"
---

Emit a `noop` safe output with the message "noop safe output from Copilot" to demonstrate the no-op safe output path.
