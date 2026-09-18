---
on:
  slash_command:
    name: test-copilot-command
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
          I'm Copilot. Here's a haiku about this repo:
            code transforms and grows
            automated paths unfold
            quality assured
  missing-tool:
---

Add a reply comment to issue #${{ github.event.issue.number }} answering the question "${{ steps.sanitized.outputs.text }}" given the context of the repo, starting with saying you're Copilot. If there is no command write out a haiku about the repo.
