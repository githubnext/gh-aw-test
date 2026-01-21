---
on:
  workflow_dispatch:
roles: ["write"]
permissions: read

engine: 
  id: claude
safe-outputs:
  create-discussion:
    title-prefix: "[claude-test] "
    # categories: [General]
    # min: 1
---

Create a discussion in repository ${{ github.repository }} with title "Hello from Claude Discussion" and body "World Discussion"

Add a haiku about GitHub Discussions and AI to the discussion body.