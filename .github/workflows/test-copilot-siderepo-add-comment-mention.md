---
on:
  workflow_dispatch:
    inputs:
      issue_number:
        description: Side-repository issue number
        required: true
        type: number
      collaborator:
        description: Collaborator to mention
        required: true
        type: string
permissions:
  contents: read
  issues: read
  copilot-requests: write
engine:
  id: copilot
safe-outputs:
  github-token: ${{ secrets.TEMP_USER_PAT || secrets.GH_AW_TEST_PAT }}
  add-comment:
    target-repo: githubnext/gh-aw-side-repo
    target: ${{ inputs.issue_number }}
    samples:
      - body: "@${{ github.event.inputs.collaborator }} mention-scoping passed."
---

    Add the comment `@${{ inputs.collaborator }} mention-scoping passed.` to issue #${{ inputs.issue_number }} in `githubnext/gh-aw-side-repo`.