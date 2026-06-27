---
on:
  workflow_dispatch:
    inputs:
      comment_node_id:
        description: "GraphQL node ID of the comment to hide"
        required: true
        type: string
      host_issue_number:
        description: "Number of the issue hosting the comment (for the add-comment validation marker)"
        required: true
        type: string
  reaction: eyes

permissions:
  contents: read
  issues: read
  copilot-requests: write

engine: 
  id: copilot

safe-outputs:
  add-comment:
    max: 1
    target: "*"
    samples:
      - item_number: "${{ github.event.inputs.host_issue_number }}"
        body: "Hidden by Copilot hide-comment safe output"
  hide-comment:
    max: 1
    # min: 1
    samples:
      - comment_id: "${{ github.event.inputs.comment_node_id }}"
        reason: "OUTDATED"
---

1. Use the `hide_comment` safe output to hide the comment whose GraphQL node ID is `${{ github.event.inputs.comment_node_id }}` with reason "OUTDATED".
2. Use the `add_comment` safe output to post the comment "Hidden by Copilot hide-comment safe output" on issue #${{ github.event.inputs.host_issue_number }} so the test can validate the workflow ran successfully.
