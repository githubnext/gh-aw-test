---
on:
  discussion:
    types: [created]
  reaction: eyes

if: contains(github.event.discussion.body, 'e2e-marker:test-copilot-close-discussion')

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
  close-discussion:
    target: "triggering"
    # min: 1
    samples:
      - body: "Closed by Copilot safe output"
        reason: "RESOLVED"
---

If the title of the discussion #${{ github.event.discussion.number }} is exactly "Test close discussion from Copilot" then close the discussion with a comment "Closed by Copilot safe output" and resolution reason "RESOLVED".
