---
on:
  label_command:
    name: test-copilot-label-command
  reaction: eyes

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
  add-comment:
    # min: 1
    samples:
      - body: |
          I'm Copilot. The label was applied! Here's a haiku about this repo:
            code transforms and grows
            automated paths unfold
            quality assured
  missing-tool:
---

Add a reply comment to issue #${{ github.event.issue.number }} acknowledging that a label was applied to the issue, and write a haiku about the repo. Start by saying you're Copilot.
