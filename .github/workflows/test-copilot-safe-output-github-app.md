---
on:
  workflow_dispatch:
    inputs:
      issue_number:
        description: Issue to comment on
        required: true
        type: number
permissions:
  contents: read
  issues: read
  copilot-requests: write
engine:
  id: copilot
safe-outputs:
  add-comment:
    target: ${{ inputs.issue_number }}
    github-app:
      client-id: ${{ vars.GH_AW_TEST_APP_CLIENT_ID }}
      private-key: ${{ secrets.GH_AW_TEST_APP_PRIVATE_KEY }}
    samples:
      - body: Per-handler GitHub App override passed.
---

Add the comment `Per-handler GitHub App override passed.` to issue #${{ inputs.issue_number }}.