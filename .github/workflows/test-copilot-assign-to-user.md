---
on:
  issues:
    types: [opened, reopened]
  reaction: eyes

permissions: read-all

engine: 
  id: copilot

safe-outputs:
  assign-to-user:
    # min: 1
---

If the title of the issue #${{ github.event.issue.number }} is exactly "Test assign to user from Copilot" then assign the user "dsyme" to the issue.
