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
  id: codex

safe-outputs:
  create-discussion:
    title-prefix: "[codex-test] "
    # categories: [General]
    # min: 1
    samples:
      - title: "Hello from Codex Discussion"
        body: |
          World Discussion

          A haiku for the test:
            threads weave through the code
            discussions shape the future
            wisdom emerges
---

Create a discussion in repository ${{ github.repository }} with title "Hello from Codex Discussion" and body "World Discussion"

Add a haiku about GitHub Discussions and AI to the discussion body.