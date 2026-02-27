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
  create-issue:
    title-prefix: "[copilot-nosandbox-test] "
    labels: [copilot, automation, haiku, nosandbox]
    # min: 1
  threat-detection: false  # Disable threat detection
---

Create an issue in repository ${{ github.repository }} with title "Hello from Copilot (No Sandbox)" and body "World"

Add a haiku about GitHub Actions and AI to the issue body.
