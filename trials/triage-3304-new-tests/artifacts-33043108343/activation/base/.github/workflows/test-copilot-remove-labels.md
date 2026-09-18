---
on:
  issues:
    types: [opened, reopened]
  reaction: eyes

if: contains(github.event.issue.body, 'e2e-marker:test-copilot-remove-labels')

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
  remove-labels:
    allowed: [copilot-remove-label-test]
    # min: 1
    samples:
      - labels: ["copilot-remove-label-test"]
---

If the title of the issue #${{ github.event.issue.number }} is "Test remove label from Copilot" then remove the label "copilot-remove-label-test" from the issue.
