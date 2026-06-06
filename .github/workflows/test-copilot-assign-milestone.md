---
on:
  issues:
    types: [opened, reopened]
  reaction: eyes

permissions: read-all

engine: 
  id: copilot

safe-outputs:
  assign-milestone:
    allowed: ["Copilot Safe Output Test Milestone"]
    # min: 1
---

If the title of the issue #${{ github.event.issue.number }} is exactly "Test assign milestone from Copilot" then assign the milestone titled "Copilot Safe Output Test Milestone" to the issue.
