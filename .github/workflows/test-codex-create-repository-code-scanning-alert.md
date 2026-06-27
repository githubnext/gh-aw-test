---
name: Test Codex Code Scanning Alert
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
  id: codex

safe-outputs:
  create-code-scanning-alert:
    max: 10
    # min: 1
    samples:
      - file: "clean.sh"
        line: 50
        severity: "warning"
        message: "Codex wants security review. Security is paramount in maintaining robust software systems. Proactive security reviews help identify and mitigate potential vulnerabilities, protecting both the codebase and its users from malicious threats."
---

# Test Codex Create Code Scanning Alert

Create a new Code Scanning Alert for the repository with title "Codex wants security review." and adding a couple of sentences about why security is important.