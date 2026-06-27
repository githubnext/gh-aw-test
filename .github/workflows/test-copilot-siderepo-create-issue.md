---
on:
  workflow_dispatch:

permissions:
  issues: read
  pull-requests: read
  actions: read
  contents: read
  discussions: read
  copilot-requests: write

engine: 
  id: copilot

tools:
  github:
    # The GitHub tools must be authorized to read across-repo 
    github-token: ${{ secrets.TEMP_USER_PAT || secrets.GH_AW_TEST_PAT }}

safe-outputs:
  github-token: ${{ secrets.TEMP_USER_PAT || secrets.GH_AW_TEST_PAT }}
  create-issue:
    title-prefix: "[copilot-test] "
    labels: [copilot, automation, haiku]
    target-repo: 'githubnext/gh-aw-side-repo'
    allowed-repos: ['githubnext/gh-aw-side-repo']
    # min: 1
    samples:
      - title: "Hello from Copilot"
        body: |
          World

          A haiku for the test:
            across repos flow
            workflows bridge the boundaries
            connections hold strong
---

Create an issue in repository githubnext/gh-aw-side-repo with title "Hello from Copilot" and body "World"

Add a haiku about GitHub Actions and AI to the issue body.
