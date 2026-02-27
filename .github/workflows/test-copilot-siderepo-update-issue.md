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
  update-issue:
    status:
    title:
    body:
    target-repo: 'githubnext/gh-aw-side-repo'
    # allowed-repos: ['githubnext/gh-aw-side-repo']
    # min: 1
---

If the title of the issue #${{ inputs.issue_number }} in repository githubnext/gh-aw-side-repo is exactly "Hello from Copilot" then:

1. Change the status to "closed"
2. Update the title to "[UPDATED] Update Issue Test - Processed by Copilot"
3. Add a line to the end of the body saying "This issue was automatically updated by the Copilot agentic workflow."
