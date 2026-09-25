---
on:
  issues:
    types: [opened, reopened]
  reaction: eyes

if: contains(github.event.issue.body, 'e2e-marker:test-copilot-unassign-from-user')

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
  unassign-from-user:
    # min: 1
    samples:
      - issue_number: ${{ github.event.issue.number }}
        assignees: ["dsyme"]
---

If the title of the issue #${{ github.event.issue.number }} is exactly "Test unassign from user from Copilot" then unassign the user "dsyme" from the issue.
