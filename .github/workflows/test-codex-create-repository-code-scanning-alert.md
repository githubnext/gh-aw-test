---
name: Test Codex Code Scanning Alert
on:
  workflow_dispatch:
  reaction: eyes

permissions: read-all

engine: 
  id: codex

safe-outputs:
  create-code-scanning-alert:
    max: 10
    # min: 1
---

# Test Codex Create Code Scanning Alert

Create a new Code Scanning Alert for the repository with title "Codex wants security review." and adding a couple of sentences about why security is important.