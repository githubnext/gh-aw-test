---
name: Test Copilot Code Scanning Alert
on:
  workflow_dispatch:
  reaction: eyes

permissions: read-all

engine: 
  id: copilot

safe-outputs:
  create-code-scanning-alert:
    max: 10
    # min: 1
    samples:
      - file: "README.md"
        line: 25
        severity: "warning"
        message: "Copilot wants security review. Security is essential for protecting our applications and user data. Regular security reviews ensure we maintain the highest standards of code quality and identify potential vulnerabilities before they can be exploited."
---

# Test Copilot Create Code Scanning Alert

Create a new Code Scanning Alert for the repository with title "Copilot wants security review." and adding a couple of sentences about why security is important.