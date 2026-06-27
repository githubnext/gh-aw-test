---
on:
  issues:
    types: [opened, reopened]
  reaction: eyes

if: contains(github.event.issue.body, 'e2e-marker:test-claude-add-comment')

permissions:
  issues: read
  pull-requests: read
  actions: read
  contents: read
  discussions: read
  security-events: read
  copilot-requests: write

engine: 
  id: claude

tools:
  github:
    toolsets: [all]
    lockdown: false # to see the comment already added

safe-outputs:
  add-comment:
    # min: 1
    samples:
      - body: "Reply from Claude"
---

If the title of the issue #${{ github.event.issue.number }} is "Hello from Claude" then add a comment on the issue "Reply from Claude".

