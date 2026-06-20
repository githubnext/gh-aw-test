---
on:
  workflow_call:
    inputs:
      sentinel:
        description: "Sentinel value for the worker-created issue title"
        required: true
        type: string

permissions:
  issues: read

engine:
  id: copilot

safe-outputs:
  create-issue:
    title-prefix: "[call-worker] "
    labels: [call-worker]
    samples:
      - title: "sentinel=${{ inputs.sentinel }}"
        body: "Issue created by Copilot call-workflow worker."
---
Create a GitHub issue titled "[call-worker] sentinel=${{ inputs.sentinel }}".
