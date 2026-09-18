---
on:
  workflow_dispatch:
    inputs:
      issue_number:
        description: Issue to close
        required: true
        type: number
      duplicate_of:
        description: Canonical issue number
        required: true
        type: number
concurrency:
  job-discriminator: ${{ github.run_id }}
permissions:
  issues: read
  contents: read
  copilot-requests: write
engine: copilot
safe-outputs:
  close-issue:
    target: "*"
    state-reason: duplicate
    samples:
      - issue_number: 1
        duplicate_of: 2
        body: "Closing this issue as a duplicate of the canonical fixture issue."
---

Close issue #${{ inputs.issue_number }} as a duplicate of #${{ inputs.duplicate_of }} using the native duplicate relationship.