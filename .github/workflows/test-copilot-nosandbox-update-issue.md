---
on:
  issues:
    types: [opened, reopened]
  reaction: eyes

if: contains(github.event.issue.body, 'e2e-marker:test-copilot-nosandbox-update-issue')

strict: false

permissions:
  issues: read
  pull-requests: read
  actions: read
  contents: read
  discussions: read
  copilot-requests: write

engine: 
  id: copilot

features:
  dangerously-disable-sandbox-agent: "test environment with no useful secrets or information"

sandbox:
  agent: false

safe-outputs:
  threat-detection: false  # Disable threat detection
  update-issue:
    status:
    title:
    body:
    # min: 1
    samples:
      - issue_number: 1
        title: "[UPDATED] Update Issue Test - Processed by Copilot (No Sandbox)"
        body: "Original body\n\nThis issue was automatically updated by the Copilot agentic workflow without sandbox protection."
        status: "closed"
---

If the title of the issue #${{ github.event.issue.number }} is exactly "Hello from Copilot (No Sandbox)" then:

1. Change the status to "closed"
2. Update the title to "[UPDATED] Update Issue Test - Processed by Copilot (No Sandbox)"
3. Add a line to the end of the body saying "This issue was automatically updated by the Copilot agentic workflow without sandbox protection."
