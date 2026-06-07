---
on:
  workflow_dispatch:
    inputs:
      issue_number:
        description: 'Issue number'
        required: true
        type: number

permissions: read-all

engine: 
  id: copilot

tools:
  github:
    # The GitHub tools must be authorized to read across-repo 
    github-token: ${{ secrets.TEMP_USER_PAT }}

safe-outputs:
  github-token: ${{ secrets.TEMP_USER_PAT }}
  add-comment:
    target-repo: 'githubnext/gh-aw-side-repo'
    allowed-repos: ['githubnext/gh-aw-side-repo']
    # min: 1
    samples:
      - item_number: ${{ github.event.inputs.issue_number }}
        body: "Reply from Copilot"
---

If the title of the issue #${{ inputs.issue_number }} in repository githubnext/gh-aw-side-repo is "Hello from Copilot" then add a comment on the issue "Reply from Copilot".
