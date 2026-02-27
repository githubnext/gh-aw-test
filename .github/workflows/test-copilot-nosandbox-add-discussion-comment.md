---
on:
  discussion:
    types: [created]
  reaction: eyes

strict: false

permissions: read-all

engine: 
  id: copilot

sandbox:
  agent: false

safe-outputs:
  add-comment:
    discussion: true
    # min: 1
  threat-detection: false  # Disable threat detection
tools:
  github:
    toolsets: [all]
---

If the title of the discussion #${{ github.event.discussion.number }} is "Hello from Copilot Discussion (No Sandbox)" then add a comment on the discussion "Reply from Copilot Discussion (No Sandbox)".
