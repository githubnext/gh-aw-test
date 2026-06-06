---
on:
  discussion:
    types: [created]
  reaction: eyes

if: contains(github.event.discussion.body, 'e2e-marker:test-copilot-add-discussion-comment')

permissions: read-all

engine: 
  id: copilot

safe-outputs:
  add-comment:
    discussions: true
    # min: 1
    samples:
      - body: "Reply from Copilot Discussion"
tools:
  github:
    toolsets: [all]
---

If the title of the discussion #${{ github.event.discussion.number }} is "Hello from Copilot Discussion" then add a comment on the discussion "Reply from Copilot Discussion".
