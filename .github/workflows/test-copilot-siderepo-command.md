---
on:
  workflow_dispatch:
    inputs:
      issue_number:
        description: 'Issue number'
        required: true
        type: number
      command_text:
        description: 'Command text'
        required: false
        type: string
        default: ''

permissions: read-all

engine: 
  id: copilot

safe-outputs:
  github-token: ${{ secrets.TEMP_USER_PAT }}
  add-comment:
    target-repo: 'githubnext/gh-aw-side-repo'
    allowed-repos: ['githubnext/gh-aw-side-repo']
    # min: 1
  missing-tool:
---

Add a reply comment to issue #${{ inputs.issue_number }} in repository githubnext/gh-aw-side-repo answering the question "${{ inputs.command_text }}" given the context of the repo, starting with saying you're Copilot. If there is no command write out a haiku about the repo.
