---
on:
  discussion:
    types: [created]
  reaction: eyes

if: contains(github.event.discussion.body, 'e2e-marker:test-claude-add-discussion-comment')

permissions:
  issues: read
  pull-requests: read
  actions: read
  contents: read
  discussions: read
  copilot-requests: write

engine: 
  id: claude

safe-outputs:
  add-comment:
    discussions: true
    # min: 1
    samples:
      - body: "Reply from Claude Discussion"

tools:
  github:
    toolsets: [discussions]
---

If the title of the discussion #${{ github.event.discussion.number }} is "Hello from Claude Discussion" then add a comment on the discussion "Reply from Claude Discussion".

