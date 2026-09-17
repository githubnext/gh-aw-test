---
on:
  workflow_dispatch:
    inputs:
      pull_request_number:
        description: Pull request opened from the configured fork
        required: true
        type: number
concurrency:
  job-discriminator: ${{ github.run_id }}
permissions:
  contents: read
  pull-requests: read
engine: copilot
safe-outputs:
  push-to-pull-request-branch:
    target: ${{ inputs.pull_request_number }}
    max: 1
timeout-minutes: 5
---

Attempt to append a line to `fork-rejection-e2e.txt` and push it to pull
request #${{ inputs.pull_request_number }}. If the fork is not authorized,
report the task incomplete and explain that the safe output rejected the fork.