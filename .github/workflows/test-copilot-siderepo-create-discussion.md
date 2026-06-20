---
on:
  workflow_dispatch:

permissions: read-all

engine: 
  id: copilot

tools:
  github:
    # The GitHub tools must be authorized to read across-repo 
    github-token: ${{ secrets.TEMP_USER_PAT || secrets.GH_AW_TEST_PAT }}

safe-outputs:
  github-token: ${{ secrets.TEMP_USER_PAT || secrets.GH_AW_TEST_PAT }}
  create-discussion:
    title-prefix: "[copilot-test] "
    target-repo: 'githubnext/gh-aw-side-repo'
    allowed-repos: ['githubnext/gh-aw-side-repo']
    # categories:
    # min: 1
    samples:
      - title: "Hello from Copilot Discussion"
        body: |
          World Discussion

          A haiku for the test:
            beyond repo walls
            discussions span the spaces
            connections expand
---

Create a discussion in repository githubnext/gh-aw-side-repo with title "Hello from Copilot Discussion" and body "World Discussion"

Add a haiku about GitHub Discussions and AI to the discussion body.
