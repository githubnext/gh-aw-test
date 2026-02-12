---
on:
  issues:
    types: [opened, reopened]
  reaction: eyes

strict: false

permissions: read-all

engine: 
  id: copilot

sandbox:
  agent: false

safe-outputs:
  add-comment:
    # min: 1
---

If the title of the issue #${{ github.event.issue.number }} is "Hello from Copilot (No Sandbox)" then add a comment on the issue "Reply from Copilot (No Sandbox)".
