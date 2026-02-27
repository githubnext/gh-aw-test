---
on:
  issues:
    types: [opened, reopened]
  reaction: eyes

strict: false

permissions: read-all

engine: 
  id: copilot

sandbox:
  agent: false

safe-outputs:
  add-labels:
    # min: 1
  threat-detection: false  # Disable threat detection
---

If the title of the issue #${{ github.event.issue.number }} is "Hello from Copilot (No Sandbox)" then add the issue label "copilot-nosandbox-safe-output-label-test" to the issue.
