---
on:
  pull_request:
    types: [opened, reopened]
  reaction: eyes

if: contains(github.event.pull_request.body, 'e2e-marker:test-copilot-update-pull-request-replace-island')

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
  update-pull-request:
    title: false
    body: true
    operation: replace-island
    footer: false
    # min: 1
    samples:
      - body: "This island was replaced by the Copilot replace-island safe output."
---

If the title of the pull request #${{ github.event.pull_request.number }} starts with "Test PR for Copilot Replace Island" then replace only the existing gh-aw island in the pull request body with:

"This island was replaced by the Copilot replace-island safe output."
