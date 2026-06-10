---
on:
  issues:
    types: [opened, reopened]
  reaction: eyes

if: contains(github.event.issue.body, 'e2e-marker:test-copilot-nosandbox-add-labels')

strict: false

permissions: read-all

engine: 
  id: copilot

features:
  dangerously-disable-sandbox-agent: "test environment with no useful secrets or information"

sandbox:
  agent: false

safe-outputs:
  add-labels:
    # min: 1
    samples:
      - labels: ["copilot-nosandbox-safe-output-label-test"]
  threat-detection: false  # Disable threat detection
---

If the title of the issue #${{ github.event.issue.number }} is "Hello from Copilot (No Sandbox)" then add the issue label "copilot-nosandbox-safe-output-label-test" to the issue.
