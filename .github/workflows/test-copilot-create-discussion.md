---
on:
  workflow_dispatch:

permissions: read

engine: 
  id: copilot

safe-outputs:
  create-discussion:
    title-prefix: "[copilot-test] "
    # categories: [General]
    # min: 1
---

Create a discussion in repository ${{ github.repository }} with title "Hello from Copilot Discussion" and body "World Discussion"

Add a haiku about GitHub Discussions and AI to the discussion body.