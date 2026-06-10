---
on:
  workflow_dispatch:

strict: false

permissions: read-all

engine: 
  id: copilot

features:
  dangerously-disable-sandbox-agent: "test environment with no useful secrets or information"

sandbox:
  agent: false

safe-outputs:
  create-discussion:
    title-prefix: "[copilot-nosandbox-test] "
    # categories: [General]
    # min: 1
    samples:
      - title: "Hello from Copilot Discussion (No Sandbox)"
        body: |
          World Discussion

          A haiku for the test:
            no walls to contain
            free flowing conversation
            open and unbound
  threat-detection: false  # Disable threat detection
---

Create a discussion in repository ${{ github.repository }} with title "Hello from Copilot Discussion (No Sandbox)" and body "World Discussion"

Add a haiku about GitHub Discussions and AI to the discussion body.
