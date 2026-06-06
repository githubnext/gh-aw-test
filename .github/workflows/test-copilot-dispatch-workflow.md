---
on:
  workflow_dispatch:
    inputs:
      sentinel:
        description: "Sentinel value to forward to the dispatched worker workflow"
        required: true
        type: string
  reaction: eyes

permissions: read-all

engine:
  id: copilot

safe-outputs:
  dispatch-workflow:
    workflows: [test-copilot-dispatch-worker]
    max: 1
    # min: 1
---

Dispatch the workflow named "test-copilot-dispatch-worker" with input `sentinel` set to "${{ github.event.inputs.sentinel }}".
