---
on:
  issues:
    types: [opened, reopened]
  reaction: eyes

strict: false

permissions: read-all

engine: 
  id: copilot

sandbox:
  agent: false

safe-outputs:
  threat-detection: false  # Disable threat detection
  update-issue:
    status:
    title:
    body:
    # min: 1
---

If the title of the issue #${{ github.event.issue.number }} is exactly "Hello from Copilot (No Sandbox)" then:

1. Change the status to "closed"
2. Update the title to "[UPDATED] Update Issue Test - Processed by Copilot (No Sandbox)"
3. Add a line to the end of the body saying "This issue was automatically updated by the Copilot agentic workflow without sandbox protection."
