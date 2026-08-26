---
on:
  pull_request:
    types: [opened, reopened]
  reaction: eyes

if: contains(github.event.pull_request.body, 'e2e-marker:test-copilot-add-labels-pull-request')

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
  add-labels:
    # min: 1
    samples:
      - labels:
          - name: "copilot-safe-output-label-test"
            rationale: "Testing the add-labels intent metadata path for pull requests"
            confidence: "HIGH"
---

If the title of the pull request #${{ github.event.pull_request.number }} starts with "Test PR for Copilot Add Labels" then add the label "copilot-safe-output-label-test" to the pull request, along with a rationale and confidence level for the label.
