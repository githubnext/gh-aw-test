---
on:
  workflow_dispatch:

strict: false

permissions: read-all

engine: 
  id: copilot

sandbox:
  agent: false

safe-outputs:
  create-discussion:
    title-prefix: "[copilot-nosandbox-test] "
    # categories: [General]
    # min: 1
  threat-detection: false  # Disable threat detection
---

Create a discussion in repository ${{ github.repository }} with title "Hello from Copilot Discussion (No Sandbox)" and body "World Discussion"

Add a haiku about GitHub Discussions and AI to the discussion body.
