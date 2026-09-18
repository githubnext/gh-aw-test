---
on:
  workflow_dispatch:
    inputs:
      sentinel:
        description: "Sentinel value to forward to the dispatched worker workflow"
        required: true
        type: string
  reaction: eyes

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
  dispatch-workflow:
    workflows: [test-copilot-dispatch-worker]
    max: 1
    # min: 1
    samples:
      - workflow_name: "test-copilot-dispatch-worker"
        inputs:
          sentinel: "${{ github.event.inputs.sentinel }}"
---

Dispatch the workflow named "test-copilot-dispatch-worker" with input `sentinel` set to "${{ github.event.inputs.sentinel }}".
