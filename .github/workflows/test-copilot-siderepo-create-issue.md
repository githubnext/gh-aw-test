---
on:
  workflow_dispatch:

permissions: read-all

engine: 
  id: copilot

safe-outputs:
  github-token: ${{ secrets.TEMP_USER_PAT }}
  create-issue:
    title-prefix: "[copilot-test] "
    labels: [copilot, automation, haiku]
    target-repo: 'githubnext/gh-aw-side-repo'
    allowed-repos: ['githubnext/gh-aw-side-repo']
    # github-token: ${{ secrets.TEMP_USER_PAT }}
    # min: 1
---

Create an issue in repository githubnext/gh-aw-side-repo with title "Hello from Copilot" and body "World"

Add a haiku about GitHub Actions and AI to the issue body.
