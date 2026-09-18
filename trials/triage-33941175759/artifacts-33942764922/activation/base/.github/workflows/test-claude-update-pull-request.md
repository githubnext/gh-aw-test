---
on:
  pull_request:
    types: [opened, reopened]
  reaction: eyes

if: contains(github.event.pull_request.body, 'e2e-marker:test-claude-update-pull-request')

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
  update-pull-request:
    title: true
    body: true
    footer: false
    # min: 1
    samples:
      - title: "[UPDATED] Update PR Test - Processed by Claude"
        body: "This pull request was automatically updated by the Claude agentic workflow."
---

If the title of the pull request #${{ github.event.pull_request.number }} starts with "Test PR for Claude" then:

1. Update the title to "[UPDATED] Update PR Test - Processed by Claude"
2. Append to the body: "This pull request was automatically updated by the Claude agentic workflow."
