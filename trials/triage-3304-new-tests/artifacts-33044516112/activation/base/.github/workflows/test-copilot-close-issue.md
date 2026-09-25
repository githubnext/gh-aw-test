---
on:
  issues:
    types: [opened, reopened]
  reaction: eyes

if: contains(github.event.issue.body, 'e2e-marker:test-copilot-close-issue')

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
  close-issue:
    target: "triggering"
    # min: 1
    samples:
      - body: "Closed by Copilot safe output"
---

If the title of the issue #${{ github.event.issue.number }} is exactly "Test close issue from Copilot" then close the issue with a comment "Closed by Copilot safe output".
