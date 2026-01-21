---
on:
  issues:
    types: [opened, reopened]
  reaction: eyes

permissions: read

engine: 
  id: claude

safe-outputs:
  add-comment:
    # min: 1
---

If the title of the issue #${{ github.event.issue.number }} is "Hello from Claude" then add a comment on the issue "Reply from Claude".

