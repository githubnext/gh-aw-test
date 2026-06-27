---
on:
  issues:
    types: [opened, reopened]
  reaction: eyes

if: contains(github.event.issue.body, 'e2e-marker:test-copilot-set-issue-type')

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
  set-issue-type:
    allowed: ["Task", "Bug", "Feature"]
    # min: 1
    samples:
      - issue_type: "Task"
---

If the title of the issue #${{ github.event.issue.number }} starts with "Test set issue type from Copilot" then set the issue type to "Task" using the `set_issue_type` safe output.
