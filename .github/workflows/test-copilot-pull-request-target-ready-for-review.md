---
on:
  pull_request_target:
    types: [opened, ready_for_review]
  reaction: eyes

if: contains(github.event.pull_request.body, 'e2e-marker:test-copilot-pull-request-target-ready-for-review')

permissions:
  issues: read
  pull-requests: read
  actions: read
  contents: read
  discussions: read
  copilot-requests: write

engine: 
  id: copilot

safe-outputs:
  add-comment:
    # min: 1
    samples:
      - body: "Reply from Copilot"
---

Add a comment on pull request #${{ github.event.pull_request.number }} saying "Reply from Copilot".
