---
name: Test Claude Code Scanning Alert
on:
  workflow_dispatch:
  reaction: eyes

permissions: read

engine: 
  id: claude

safe-outputs:
  create-code-scanning-alert:
    max: 10
    # min: 1
---

# Test Claude Create Code Scanning Alert

Create a new Code Scanning Alert for the repository with title "Claude wants security review." and adding a couple of sentences about why security is important.