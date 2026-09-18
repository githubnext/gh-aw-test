---
on:
  issues:
    types: [opened, reopened]
  reaction: eyes

if: contains(github.event.issue.body, 'e2e-marker:test-copilot-add-comment')

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
  add-comment:
    # min: 1
    samples:
      - body: "Reply from Copilot"
---

If the title of the issue #${{ github.event.issue.number }} is "Hello from Copilot" then add a comment on the issue "Reply from Copilot".
