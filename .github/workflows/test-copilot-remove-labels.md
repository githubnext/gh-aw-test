---
on:
  issues:
    types: [opened, reopened]
  reaction: eyes

permissions: read-all

engine: 
  id: copilot

safe-outputs:
  remove-labels:
    allowed: [copilot-remove-label-test]
    # min: 1
---

If the title of the issue #${{ github.event.issue.number }} is "Test remove label from Copilot" then remove the label "copilot-remove-label-test" from the issue.
