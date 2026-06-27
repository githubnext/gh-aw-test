---
on:
  issues:
    types: [opened, reopened]
  reaction: eyes

if: contains(github.event.issue.body, 'e2e-marker:test-copilot-assign-to-user')

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
  assign-to-user:
    # min: 1
    samples:
      - issue_number: ${{ github.event.issue.number }}
        assignees: ["dsyme"]
---

If the title of the issue #${{ github.event.issue.number }} is exactly "Test assign to user from Copilot" then assign the user "dsyme" to the issue.
