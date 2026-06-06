---
on:
  discussion:
    types: [created]
  reaction: eyes

if: contains(github.event.discussion.body, 'e2e-marker:test-codex-add-discussion-comment')

permissions: read-all

engine: 
  id: codex

safe-outputs:
  add-comment:
    discussions: true
    samples:
      - body: "Reply from Codex Discussion"
tools:
  github:
    toolsets: [all]
---

If the title of the discussion #${{ github.event.discussion.number }} is "Hello from Codex Discussion" then add a comment on the discussion "Reply from Codex Discussion".
