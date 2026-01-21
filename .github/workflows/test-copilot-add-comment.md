---
on:
  issues:
    types: [opened, reopened]
  reaction: eyes

permissions: read-all

engine: 
  id: copilot

safe-outputs:
  add-comment:
    # min: 1
---

If the title of the issue #${{ github.event.issue.number }} is "Hello from Copilot" then add a comment on the issue "Reply from Copilot".
