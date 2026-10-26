---
on:
  workflow_dispatch:
    inputs:
      discussion_number:
        description: Discussion to comment on
        required: true
        type: number
permissions:
  discussions: read
  copilot-requests: write
engine:
  id: copilot
safe-outputs:
  add-comment:
    discussions: true
    target: ${{ inputs.discussion_number }}
    samples:
      - body: Reply from Copilot Discussion Dispatch
---

Add the comment `Reply from Copilot Discussion Dispatch` to discussion #${{ inputs.discussion_number }}.