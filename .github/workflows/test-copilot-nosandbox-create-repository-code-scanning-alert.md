---
name: Test Copilot Code Scanning Alert (No Sandbox)
on:
  workflow_dispatch:
  reaction: eyes

strict: false

permissions: read-all

engine: 
  id: copilot

features:
  dangerously-disable-sandbox-agent: "test environment with no useful secrets or information"

sandbox:
  agent: false

safe-outputs:
  create-code-scanning-alert:
    max: 10
    # min: 1
    samples:
      - file: "ERROR_HANDLING_ASSESSMENT.md"
        line: 30
        severity: "warning"
        message: "Copilot (No Sandbox) wants security review. Security remains critical even without sandbox protection. Comprehensive security reviews help maintain code integrity and protect against threats, ensuring our systems remain trustworthy and resilient."
  threat-detection: false  # Disable threat detection
---

# Test Copilot Create Code Scanning Alert (No Sandbox)

Create a new Code Scanning Alert for the repository. The alert message must begin with "Copilot (No Sandbox) wants security review." and include a couple of sentences about why security is important even without sandbox protection.
