---
on:
  workflow_dispatch:
    inputs:
      pull_request_number:
        description: Pull request to review
        required: true
        type: number
      commit_id:
        description: Commit SHA to attribute the review to
        required: true
        type: string
permissions:
  contents: read
  pull-requests: read
  copilot-requests: write
engine:
  id: copilot
safe-outputs:
  submit-pull-request-review:
    target: ${{ inputs.pull_request_number }}
    commit-id: ${{ inputs.commit_id }}
    allowed-events: [COMMENT]
    max: 1
    samples:
      - body: Review pinned to the requested commit.
        event: COMMENT
---

Submit a COMMENT review on pull request #${{ inputs.pull_request_number }} with body `Review pinned to the requested commit.`.