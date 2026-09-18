---
on:
  issues:
    types: [opened, reopened]
  reaction: eyes

if: contains(github.event.issue.body, 'e2e-marker:test-codex-add-labels')

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
  add-labels:
    # min: 1
    samples:
      - labels: ["codex-safe-output-label-test"]
---

If the title of the issue #${{ github.event.issue.number }} is "Hello from Codex" then add the issue label "codex-safe-output-label-test" to the issue.

