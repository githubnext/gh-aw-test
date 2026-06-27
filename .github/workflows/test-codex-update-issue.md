---
on:
  issues:
    types: [opened, reopened]
  reaction: eyes

if: contains(github.event.issue.body, 'e2e-marker:test-codex-update-issue')

permissions:
  issues: read
  pull-requests: read
  actions: read
  contents: read
  discussions: read
  copilot-requests: write

engine: 
  id: codex

safe-outputs:
  update-issue:
    status:
    title:
    body:
    samples:
      - status: "closed"
        title: "[UPDATED] Update Issue Test - Processed by Codex"
        body: "This issue was automatically updated by the Codex agentic workflow."
---

If the title of the issue #${{ github.event.issue.number }} is exactly "Hello from Codex" then:

1. Change the status to "closed"
2. Update the title to "[UPDATED] Update Issue Test - Processed by Codex"
3. Add a line to the end of the body saying "This issue was automatically updated by the Codex agentic workflow."
