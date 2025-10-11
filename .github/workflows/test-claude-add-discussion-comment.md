---
on:
  issues:
    types: [opened, reopened]
  reaction: eyes

engine: 
  id: claude

safe-outputs:
  add-comment:
    discussion: true
    # min: 1
---

If the title of the issue #${{ github.event.issue.number }} is "Hello from Claude Discussion" then add a comment on the issue "Reply from Claude Discussion".

