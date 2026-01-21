---
on:
  issues:
    types: [opened, reopened]
  reaction: eyes

permissions: read-all

engine: 
  id: codex

safe-outputs:
  add-comment:
---

If the title of the issue #${{ github.event.issue.number }} is "Hello from Codex" then add a comment on the issue "Reply from Codex".

