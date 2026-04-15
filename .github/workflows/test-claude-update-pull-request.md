---
on:
  pull_request:
    types: [opened, reopened]
  reaction: eyes

permissions: read-all

engine: 
  id: claude

safe-outputs:
  update-pull-request:
    title: true
    body: true
    footer: false
    # min: 1
---

If the title of the pull request #${{ github.event.pull_request.number }} starts with "Test PR for Claude" then:

1. Update the title to "[UPDATED] Update PR Test - Processed by Claude"
2. Append to the body: "This pull request was automatically updated by the Claude agentic workflow."
