---
on:
  discussion:
    types: [created]
  reaction: eyes

if: contains(github.event.discussion.body, 'e2e-marker:test-copilot-nosandbox-add-discussion-comment')

strict: false

permissions:
  issues: read
  pull-requests: read
  actions: read
  contents: read
  discussions: read
  security-events: read
  copilot-requests: write

engine: 
  id: copilot

features:
  dangerously-disable-sandbox-agent: "test environment with no useful secrets or information"

sandbox:
  agent: false

safe-outputs:
  add-comment:
    discussions: true
    # min: 1
    samples:
      - body: "Reply from Copilot (No Sandbox) Discussion"
  threat-detection: false  # Disable threat detection
tools:
  github:
    toolsets: [all]
---

If the title of the discussion #${{ github.event.discussion.number }} is "Hello from Copilot (No Sandbox) Discussion" then add a comment on the discussion "Reply from Copilot (No Sandbox) Discussion".
