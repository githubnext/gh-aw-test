---
on:
  slash_command:
    name: test-codex-command
  reaction: eyes

permissions: read-all

engine: 
  id: claude

safe-outputs:
  add-comment:
    # min: 1
    samples:
      - body: |
          I'm Codex. Here's a haiku about this repo:
            lines of code align
            testing flows like poetry
            bugs fade into night
  missing-tool:
---

Add a reply comment to issue #${{ github.event.issue.number }} answering the question "${{ steps.sanitized.outputs.text }}" given the context of the repo, starting with saying you're Codex. If there is no command write out a haiku about the repo.

