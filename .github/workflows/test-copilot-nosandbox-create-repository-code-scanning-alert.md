---
name: Test Copilot Code Scanning Alert (No Sandbox)
on:
  workflow_dispatch:
  reaction: eyes

strict: false

permissions: read-all

engine: 
  id: copilot

sandbox:
  agent: false

safe-outputs:
  create-code-scanning-alert:
    max: 10
    # min: 1
  threat-detection: false  # Disable threat detection
---

# Test Copilot Create Code Scanning Alert (No Sandbox)

Create a new Code Scanning Alert for the repository with title "Copilot (No Sandbox) wants security review." and adding a couple of sentences about why security is important even without sandbox protection.
