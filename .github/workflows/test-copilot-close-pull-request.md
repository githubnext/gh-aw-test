---
on:
  pull_request:
    types: [opened, reopened]
  reaction: eyes

if: contains(github.event.pull_request.body, 'e2e-marker:test-copilot-close-pull-request')

permissions: read-all

engine: 
  id: copilot

safe-outputs:
  close-pull-request:
    target: "triggering"
    # min: 1
    samples:
      - body: "Closed by Copilot safe output"
---

If the title of the pull request #${{ github.event.pull_request.number }} starts with "Test PR for Copilot Close" then close the pull request with a comment "Closed by Copilot safe output".
