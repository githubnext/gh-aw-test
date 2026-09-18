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

safe-outputs:
  create-discussion:
    title-prefix: "[copilot-test] "
    # categories: [General]
    # min: 1
    samples:
      - title: "Hello from Copilot Discussion"
        body: |
          World Discussion

          A haiku for the test:
            voices converge here
            AI and humans unite
            knowledge shared freely
---

Create a discussion in repository ${{ github.repository }} with title "Hello from Copilot Discussion" and body "World Discussion"

Add a haiku about GitHub Discussions and AI to the discussion body.