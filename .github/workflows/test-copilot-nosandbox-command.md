---
on:
  slash_command:
    name: test-copilot-nosandbox-command
  reaction: eyes

strict: false

permissions: read-all

engine: 
  id: copilot

sandbox:
  agent: false

safe-outputs:
  add-comment:
    # min: 1
  missing-tool:
---

Add a reply comment to issue #${{ github.event.issue.number }} answering the question "${{ needs.activation.outputs.text }}" given the context of the repo, starting with saying you're Copilot (No Sandbox). If there is no command write out a haiku about the repo.
