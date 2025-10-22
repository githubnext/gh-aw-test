---
on:
  discussion:
    types: [created]
  reaction: eyes

engine: 
  id: codex

safe-outputs:
  add-comment:
    discussion: true
tools:
  github:
    toolset: [all]
---

If the title of the discussion #${{ github.event.discussion.number }} is "Hello from Codex Discussion" then add a comment on the discussion "Reply from Codex Discussion".
