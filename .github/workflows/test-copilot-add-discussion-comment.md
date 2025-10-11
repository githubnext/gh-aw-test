---
on:
  issues:
    types: [opened, reopened]
  reaction: eyes

engine: 
  id: copilot

safe-outputs:
  add-comment:
    discussion: true
    min: 1
---

If the title of the issue #${{ github.event.issue.number }} is "Hello from Copilot Discussion" then add a comment on the issue "Reply from Copilot Discussion".