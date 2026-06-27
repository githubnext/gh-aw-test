---
name: Test Claude Code Scanning Alert
on:
  workflow_dispatch:
  reaction: eyes

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
  create-code-scanning-alert:
    max: 10
    # min: 1
    samples:
      - file: "e2e.sh"
        line: 100
        severity: "warning"
        message: "Claude wants security review. Security is the foundation of trust in software systems. Regular security reviews help identify vulnerabilities before they can be exploited, ensuring our users' data remains protected."
---

# Test Claude Create Code Scanning Alert

Create a new Code Scanning Alert for the repository with title "Claude wants security review." and adding a couple of sentences about why security is important.