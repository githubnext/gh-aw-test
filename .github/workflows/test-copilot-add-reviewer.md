---
on:
  pull_request:
    types: [opened, reopened]
  reaction: eyes

permissions: read-all

engine: 
  id: copilot

safe-outputs:
  add-reviewer:
    allowed-reviewers: [copilot]
    # min: 1
---

If the title of the pull request #${{ github.event.pull_request.number }} starts with "Test PR for Copilot Add Reviewer" then add "copilot" as a reviewer to the pull request.
