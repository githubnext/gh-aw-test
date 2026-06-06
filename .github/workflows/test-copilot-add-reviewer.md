---
on:
  pull_request:
    types: [opened, reopened]
  reaction: eyes

if: contains(github.event.pull_request.body, 'e2e-marker:test-copilot-add-reviewer')

permissions: read-all

engine: 
  id: copilot

safe-outputs:
  add-reviewer:
    allowed-reviewers: [copilot]
    # min: 1
    samples:
      - reviewers: ["copilot"]
---

If the title of the pull request #${{ github.event.pull_request.number }} starts with "Test PR for Copilot Add Reviewer" then add "copilot" as a reviewer to the pull request.
