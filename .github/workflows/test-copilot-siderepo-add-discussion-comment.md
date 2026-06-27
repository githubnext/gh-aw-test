---
on:
  workflow_dispatch:
    inputs:
      discussion_number:
        description: 'Discussion number'
        required: true
        type: number

permissions:
  issues: read
  pull-requests: read
  actions: read
  contents: read
  discussions: read
  security-events: read
  copilot-requests: write

engine: 
  id: copilot

tools:
  github:
    # The GitHub tools must be authorized to read across-repo 
    github-token: ${{ secrets.TEMP_USER_PAT || secrets.GH_AW_TEST_PAT }}
    toolsets: [all]

safe-outputs:
  github-token: ${{ secrets.TEMP_USER_PAT || secrets.GH_AW_TEST_PAT }}
  add-comment:
    discussions: true
    target-repo: 'githubnext/gh-aw-side-repo'
    allowed-repos: ['githubnext/gh-aw-side-repo']
    # min: 1
    samples:
      - item_number: ${{ github.event.inputs.discussion_number }}
        body: "Reply from Copilot Discussion"
---

If the title of the discussion #${{ inputs.discussion_number }} in repository githubnext/gh-aw-side-repo is "Hello from Copilot Discussion" then add a comment on the discussion "Reply from Copilot Discussion".
