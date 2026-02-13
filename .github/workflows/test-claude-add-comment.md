---
on:
  issues:
    types: [opened, reopened]
  reaction: eyes

permissions: read-all

engine: 
  id: claude

tools:
  github:
    toolsets: [all]
    lockdown: false # to see the comment already added

safe-outputs:
  add-comment:
    # min: 1
---

If the title of the issue #${{ github.event.issue.number }} is "Hello from Claude" then add a comment on the issue "Reply from Claude".

