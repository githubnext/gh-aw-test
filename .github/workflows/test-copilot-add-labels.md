---
on:
  issues:
    types: [opened, reopened]
  reaction: eyes

if: contains(github.event.issue.body, 'e2e-marker:test-copilot-add-labels')

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
  add-labels:
    # min: 1
    samples:
      - labels: ["copilot-safe-output-label-test"]
---

If the title of the issue #${{ github.event.issue.number }} is "Hello from Copilot" then add the issue label "copilot-safe-output-label-test" to the issue.
