---
on:
  workflow_dispatch:
  reaction: eyes

permissions: read-all

engine: 
  id: copilot

safe-outputs:
  create-code-scanning-alert:
    max: 10
    # target-repo: 'githubnext/gh-aw-side-repo'
    # allowed-repos: ['githubnext/gh-aw-side-repo']
    # github-token: ${{ secrets.TEMP_USER_PAT }}
    # min: 1
---

Create a Code Scanning Alert in repository githubnext/gh-aw-side-repo with the title "Copilot wants security review."

Write a few sentences about the importance of security in the alert message body.
