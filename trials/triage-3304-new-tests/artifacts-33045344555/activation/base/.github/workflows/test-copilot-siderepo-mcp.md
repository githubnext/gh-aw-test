---
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
  id: copilot

tools:
  github:
    # The GitHub tools must be authorized to read across-repo 
    github-token: ${{ secrets.TEMP_USER_PAT || secrets.GH_AW_TEST_PAT }}

safe-outputs:
  github-token: ${{ secrets.TEMP_USER_PAT || secrets.GH_AW_TEST_PAT }}
  create-issue:
    target-repo: 'githubnext/gh-aw-side-repo'
    allowed-repos: ['githubnext/gh-aw-side-repo']
    # min: 1
    samples:
      - title: "Hello from Copilot"
        body: |
          The current time is 2024-01-15T10:30:00Z (retrieved from MCP time tool)
          Successfully used the MCP time tool
          
          This issue was created by an AI agent (Copilot).
---

Get the current time using the MCP time tool.

Then create an issue in repository githubnext/gh-aw-side-repo with title "Hello from Copilot" containing:
- The current time you retrieved from the MCP tool
- A statement about whether you successfully used the MCP time tool

Add a footer saying "This issue was created by an AI agent (Copilot)".
