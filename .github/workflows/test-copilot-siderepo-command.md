---
on:
  slash_command:
    name: test-copilot-siderepo-command
  reaction: eyes

permissions: read-all

engine: 
  id: copilot

safe-outputs:
  add-comment:
    target-repo: 'githubnext/gh-aw-side-repo'
    allowed-repos: ['githubnext/gh-aw-side-repo']
    # github-token: ${{ secrets.TEMP_USER_PAT }}
    # min: 1
  missing-tool:
---

Add a reply comment to issue #${{ github.event.issue.number }} in repository githubnext/gh-aw-side-repo answering the question "${{ needs.activation.outputs.text }}" given the context of the repo, starting with saying you're Copilot. If there is no command write out a haiku about the repo.
