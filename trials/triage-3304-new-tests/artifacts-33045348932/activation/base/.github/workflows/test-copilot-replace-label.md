---
on:
  issues:
    types: [opened, reopened]
  reaction: eyes

if: contains(github.event.issue.body, 'e2e-marker:test-copilot-replace-label')

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
  replace-label:
    allowed-transitions:
      - from: copilot-remove-label-test
        to: copilot-safe-output-label-test
---

On issue #${{ github.event.issue.number }}, replace the label "copilot-remove-label-test" with "copilot-safe-output-label-test" using the `replace_label` safe output.