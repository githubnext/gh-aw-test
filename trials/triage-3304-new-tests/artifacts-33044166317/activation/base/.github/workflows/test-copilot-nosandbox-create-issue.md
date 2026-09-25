---
on:
  workflow_dispatch:

strict: false

permissions:
  issues: read
  pull-requests: read
  actions: read
  contents: read
  discussions: read
  copilot-requests: write

engine: 
  id: copilot

features:
  dangerously-disable-sandbox-agent: "test environment with no useful secrets or information"

sandbox:
  agent: false

safe-outputs:
  create-issue:
    title-prefix: "[copilot-nosandbox-test] "
    labels: [copilot, automation, haiku, nosandbox]
    # min: 1
    samples:
      - title: "Hello from Copilot (No Sandbox)"
        body: |
          World

          A haiku for the test:
            no sandbox constrains
            free flowing code and data
            trust in the process
  threat-detection: false  # Disable threat detection
---

Create an issue in repository ${{ github.repository }} with title "Hello from Copilot (No Sandbox)" and body "World"

Add a haiku about GitHub Actions and AI to the issue body.
