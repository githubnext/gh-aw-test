---
on:
  workflow_dispatch:

permissions:
  actions: read
  contents: read
  pull-requests: read
  copilot-requests: write

engine:
  id: copilot

safe-outputs:
  approve-workflow-run:
    staged: true
    allowed-workflows:
      - "*.yml"
    # min: 1
    samples:
      - run_id: 123456789
---

Emit an `approve_workflow_run` safe output for run ID 123456789 to exercise the staged approval path with default pull request commenting enabled.
