---
on:
  command:
    name: test-claude-command
  reaction: eyes

engine: 
  id: claude

safe-outputs:
  add-issue-comment:
  missing-tool:
---

Add a reply comment to issue #${{ github.event.issue.number }} answering the question "${{ needs.task.outputs.text }}" given the context of the repo, starting with saying you're Claude. If there is no command write out a haiku about the repo.

