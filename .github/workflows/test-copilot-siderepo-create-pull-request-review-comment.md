---
on:
  slash_command:
    name: test-copilot-siderepo-create-pull-request-review-comment
  reaction: eyes

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

Analyze the pull request #${{ github.event.pull_request.number }} in repository githubnext/gh-aw-side-repo.

Create 1 review comment on the second line of the first hunk of the first file in the PR, praising the code and suggesting it looks great.
