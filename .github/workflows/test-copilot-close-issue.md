---
on:
  issues:
    types: [opened, reopened]
  reaction: eyes

if: contains(github.event.issue.body, 'e2e-marker:test-copilot-close-issue')

permissions: read-all

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
