---
on:
  workflow_dispatch:
    inputs:
      sentinel:
        description: "Sentinel value to forward to the called worker workflow"
        required: true
        type: string
  reaction: eyes

permissions:
  issues: read
  copilot-requests: write

engine:
  id: copilot

safe-outputs:
  call-workflow:
    workflows: [test-copilot-call-worker]
    max: 1
    # min: 1
    samples:
      - workflow_name: "test-copilot-call-worker"
        inputs:
          sentinel: "${{ github.event.inputs.sentinel }}"
---

Call the reusable workflow named "test-copilot-call-worker" with input `sentinel` set to "${{ github.event.inputs.sentinel }}" using the `call_workflow` safe output.
