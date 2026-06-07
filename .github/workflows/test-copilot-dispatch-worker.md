---
on:
  workflow_dispatch:
    inputs:
      sentinel:
        description: "Sentinel value to include in the dispatched issue title"
        required: true
        type: string

permissions: read-all

engine:
  id: copilot

safe-outputs:
  create-issue:
    title-prefix: "[dispatch-worker] "
    labels: [dispatch-worker]
    # min: 1
    samples:
      - title: "sentinel=${{ github.event.inputs.sentinel }}"
        body: "Issue created by Copilot dispatch-workflow safe output test worker."
---

Create a single GitHub issue with the title "[dispatch-worker] sentinel=${{ github.event.inputs.sentinel }}" and body "Issue created by Copilot dispatch-workflow safe output test worker.".
