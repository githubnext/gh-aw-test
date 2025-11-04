---
on:
  issues:
    types: [opened, reopened]
  reaction: eyes

engine: 
  id: copilot

safe-outputs:
  add-labels:
    # min: 1
---

If the title of the issue #${{ github.event.issue.number }} is "Hello from Copilot" then add the issue label "copilot-safe-output-label-test" to the issue.