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

permissions:
  issues: read
  pull-requests: read
  actions: read
  contents: read
  discussions: read
  copilot-requests: write

engine:
  id: copilot

tools:
  github:
    # The GitHub tools must be authorized to read across-repo
    github-token: ${{ secrets.TEMP_USER_PAT || secrets.GH_AW_TEST_PAT }}

safe-outputs:
  link-sub-issue:
    target-repo: "githubnext/gh-aw-side-repo"
    allowed-repos: ["${{ github.repository_owner }}/gh-aw-side-repo"]
    github-token: ${{ secrets.TEMP_USER_PAT || secrets.GH_AW_TEST_PAT }}
    # min: 1
    samples:
      - parent_issue_number: "${{ github.event.inputs.parent_issue_number }}"
        sub_issue_number: "${{ github.event.inputs.sub_issue_number }}"
---

Link issue #${{ github.event.inputs.sub_issue_number }} as a sub-issue of issue #${{ github.event.inputs.parent_issue_number }} in githubnext/gh-aw-side-repo using the `link_sub_issue` safe output (parent_issue_number=${{ github.event.inputs.parent_issue_number }}, sub_issue_number=${{ github.event.inputs.sub_issue_number }}).
