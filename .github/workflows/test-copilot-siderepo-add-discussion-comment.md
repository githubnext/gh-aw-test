---
on:
  discussion:
    types: [created]
  reaction: eyes

permissions: read-all

engine: 
  id: copilot

safe-outputs:
  add-comment:
    discussion: true
    target-repo: 'githubnext/gh-aw-side-repo'
    allowed-repos: ['githubnext/gh-aw-side-repo']
    # github-token: ${{ secrets.TEMP_USER_PAT }}
    # min: 1
---

If the title of the discussion #${{ github.event.discussion.number }} in repository githubnext/gh-aw-side-repo is "Hello from Copilot Discussion" then add a comment on the discussion "Reply from Copilot Discussion".
