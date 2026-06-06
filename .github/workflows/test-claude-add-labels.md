---
on:
  issues:
    types: [opened, reopened]
  reaction: eyes

if: contains(github.event.issue.body, 'e2e-marker:test-claude-add-labels')

permissions: read-all

engine: 
  id: claude

safe-outputs:
  add-labels:
    # min: 1
    samples:
      - labels: ["claude-safe-output-label-test"]
---

If the title of the issue #${{ github.event.issue.number }} is exactly "Hello from Claude" then add the issue label "claude-safe-output-label-test" to the issue.

