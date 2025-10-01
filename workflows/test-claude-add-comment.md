---
on:
  issues:
    types: [opened, reopened]
  reaction: eyes

engine: 
  id: claude

safe-outputs:
  add-comment:
---

If the title of the issue #${{ github.event.issue.number }} is "Hello from Claude" then add a comment on the issue "Reply from Claude".

