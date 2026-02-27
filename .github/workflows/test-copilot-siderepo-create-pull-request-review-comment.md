---
on:
  workflow_dispatch:
    inputs:
      pull_request_number:
        description: 'Pull request number'
        required: true
        type: number

permissions: read-all

engine: 
  id: copilot

safe-outputs:
  create-pull-request-review-comment:
    max: 3
    target-repo: 'githubnext/gh-aw-side-repo'
    allowed-repos: ['githubnext/gh-aw-side-repo']
    github-token: ${{ secrets.TEMP_USER_PAT }}
    # min: 1
---

Analyze the pull request #${{ inputs.pull_request_number }} in repository githubnext/gh-aw-side-repo.

Create 1 review comment on the second line of the first hunk of the first file in the PR, praising the code and suggesting it looks great.
