---
on:
  workflow_dispatch:
    inputs:
      parent_issue_number:
        description: "Parent issue number"
        required: true
        type: string
      sub_issue_number:
        description: "Sub issue number to link under the parent"
        required: true
        type: string
  reaction: eyes

permissions: read-all

engine: 
  id: copilot

safe-outputs:
  link-sub-issue:
    # min: 1
    samples:
      - parent_issue_number: "${{ github.event.inputs.parent_issue_number }}"
        sub_issue_number: "${{ github.event.inputs.sub_issue_number }}"
---

Link issue #${{ github.event.inputs.sub_issue_number }} as a sub-issue of issue #${{ github.event.inputs.parent_issue_number }} using the `link_sub_issue` safe output (parent_issue_number=${{ github.event.inputs.parent_issue_number }}, sub_issue_number=${{ github.event.inputs.sub_issue_number }}).
