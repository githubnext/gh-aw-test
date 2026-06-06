---
on:
  issues:
    types: [opened, reopened]
  reaction: eyes

if: contains(github.event.issue.body, 'e2e-marker:test-copilot-assign-milestone')

permissions: read-all

engine: 
  id: copilot

safe-outputs:
  assign-milestone:
    allowed: ["Copilot Safe Output Test Milestone"]
    # min: 1
    samples:
      - issue_number: 123
        milestone_title: "Copilot Safe Output Test Milestone"
---

If the title of the issue #${{ github.event.issue.number }} is exactly "Test assign milestone from Copilot" then assign the milestone titled "Copilot Safe Output Test Milestone" to the issue.
