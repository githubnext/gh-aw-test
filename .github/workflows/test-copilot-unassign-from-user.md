---
on:
  issues:
    types: [opened, reopened]
  reaction: eyes

permissions: read-all

engine: 
  id: copilot

safe-outputs:
  unassign-from-user:
    # min: 1
---

If the title of the issue #${{ github.event.issue.number }} is exactly "Test unassign from user from Copilot" then unassign the user "dsyme" from the issue.
