---
on:
  command:
    name: test-copilot-command
  reaction: eyes

permissions: read

engine: 
  id: claude

safe-outputs:
  add-comment:
    # min: 1
  missing-tool:
---

Add a reply comment to issue #${{ github.event.issue.number }} answering the question "${{ needs.activation.outputs.text }}" given the context of the repo, starting with saying you're Copilot. If there is no command write out a haiku about the repo.