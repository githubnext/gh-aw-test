---
on:
  slash_command:
    name: test-claude-command
  reaction: eyes

permissions:
  issues: read
  pull-requests: read
  actions: read
  contents: read
  discussions: read
  copilot-requests: write


engine: 
  id: claude

safe-outputs:
  add-comment:
    # min: 1
    samples:
      - body: |
          I'm Claude. Here's a haiku about this repo:
            workflows dance here
            automation takes the stage
            tests pass, all is well
  missing-tool:
---

Add a reply comment to issue #${{ github.event.issue.number }} answering the question "${{ steps.sanitized.outputs.text }}" given the context of the repo, starting with saying you're Claude. If there is no command write out a haiku about the repo.

