---
on:
  workflow_dispatch:
    inputs:
      sentinel:
        description: Marker forwarded to the worker
        required: true
        type: string
permissions:
  actions: read
  contents: read
  copilot-requests: write
engine:
  id: copilot
safe-outputs:
  dispatch-workflow:
    workflows: [test-copilot-dispatch-worker]
    allowed-refs: [main]
    max: 1
    samples:
      - workflow_name: test-copilot-dispatch-worker
        ref: main
        inputs:
          sentinel: ${{ inputs.sentinel }}
---

Dispatch `test-copilot-dispatch-worker` with ref `main` and input `sentinel` set to `${{ inputs.sentinel }}`.