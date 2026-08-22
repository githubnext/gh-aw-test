---
on:
  workflow_dispatch:
    inputs:
      pull_request_number:
        description: 'Pull request number to review and dismiss'
        required: true
        type: number

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
  steps:
    - name: Create review fixture
      env:
        GH_TOKEN: ${{ github.token }}
        PR_NUMBER: ${{ github.event.inputs.pull_request_number }}
      run: |
        gh api --method POST \
          "repos/${{ github.repository }}/pulls/${PR_NUMBER}/reviews" \
          --field event=REQUEST_CHANGES \
          --field body="Review created for the dismiss-pull-request-review E2E test."
  dismiss-pull-request-review:
    max: 1
    target: "*"
    samples:
      - pull_request_number: "${{ github.event.inputs.pull_request_number }}"
        justification: "Dismissed by the Copilot dismiss-pull-request-review E2E test."
---

On pull request #${{ github.event.inputs.pull_request_number }}, dismiss the review authored by the current workflow actor without specifying `review_id`, using the justification "Dismissed by the Copilot dismiss-pull-request-review E2E test."