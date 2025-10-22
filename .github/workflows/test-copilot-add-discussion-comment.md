---
on:
  discussion:
    types: [created]
  reaction: eyes

engine: 
  id: copilot

safe-outputs:
  add-comment:
    discussion: true
    min: 1
tools:
  github:
    toolset: [all]
---

If the title of the discussion #${{ github.event.discussion.number }} is "Hello from Copilot Discussion" then add a comment on the discussion "Reply from Copilot Discussion".