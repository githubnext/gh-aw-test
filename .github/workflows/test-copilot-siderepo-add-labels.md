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

safe-outputs:
  add-labels:
    target-repo: 'githubnext/gh-aw-side-repo'
    allowed-repos: ['githubnext/gh-aw-side-repo']
    github-token: ${{ secrets.TEMP_USER_PAT }}
    # min: 1
---

If the title of the issue #${{ inputs.issue_number }} in repository githubnext/gh-aw-side-repo is "Hello from Copilot" then add the label "copilot-safe-output-label-test" to the issue.
