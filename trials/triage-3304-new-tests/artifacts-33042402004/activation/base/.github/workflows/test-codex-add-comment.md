---
on:
  issues:
    types: [opened, reopened]
  reaction: eyes

if: contains(github.event.issue.body, 'e2e-marker:test-codex-add-comment')

permissions:
  issues: read
  pull-requests: read
  actions: read
  contents: read
  discussions: read
  copilot-requests: write

engine: 
  id: codex

safe-outputs:
  add-comment:
    samples:
      - body: "Reply from Codex"
---

If the title of the issue #${{ github.event.issue.number }} is "Hello from Codex" then add a comment on the issue "Reply from Codex".

