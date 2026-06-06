---
on:
  workflow_dispatch:
  roles: ["write"]

permissions: read-all

engine: 
  id: claude
safe-outputs:
  create-discussion:
    title-prefix: "[claude-test] "
    # categories: [General]
    # min: 1
    samples:
      - title: "Hello from Claude Discussion"
        body: |
          World Discussion

          A haiku for the test:
            replay drives the thread
            no model awakens here
            outputs flow at last
---

Create a discussion in repository ${{ github.repository }} with title "Hello from Claude Discussion" and body "World Discussion"

Add a haiku about GitHub Discussions and AI to the discussion body.