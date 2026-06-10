---
on:
  slash_command:
    name: test-copilot-nosandbox-command
  reaction: eyes

strict: false

permissions: read-all

engine: 
  id: copilot

features:
  dangerously-disable-sandbox-agent: "test environment with no useful secrets or information"

sandbox:
  agent: false

safe-outputs:
  add-comment:
    # min: 1
    samples:
      - body: |
          I'm Copilot (No Sandbox). Here's a haiku about this repo:
            freedom to explore
            unrestricted code pathways
            innovation blooms
  missing-tool:
  threat-detection: false  # Disable threat detection
---

Add a reply comment to issue #${{ github.event.issue.number }} answering the question "${{ steps.sanitized.outputs.text }}" given the context of the repo, starting with saying you're Copilot (No Sandbox). If there is no command write out a haiku about the repo.
