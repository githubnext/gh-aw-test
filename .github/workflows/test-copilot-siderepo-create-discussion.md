---
on:
  workflow_dispatch:

permissions: read-all

engine: 
  id: copilot

safe-outputs:
  create-discussion:
    title-prefix: "[copilot-test] "
    target-repo: 'githubnext/gh-aw-side-repo'
    allowed-repos: ['githubnext/gh-aw-side-repo']
    # github-token: ${{ secrets.TEMP_USER_PAT }}
    # categories:
    # min: 1
---

Create a discussion in repository githubnext/gh-aw-side-repo with title "Hello from Copilot Discussion" and body "World Discussion"

Add a haiku about GitHub Discussions and AI to the discussion body.
