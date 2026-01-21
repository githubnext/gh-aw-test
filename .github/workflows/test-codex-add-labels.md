---
on:
  issues:
    types: [opened, reopened]
  reaction: eyes

permissions: read-all

engine: 
  id: codex

safe-outputs:
  add-labels:
    # min: 1
---

If the title of the issue #${{ github.event.issue.number }} is "Hello from Codex" then add the issue label "codex-safe-output-label-test" to the issue.

