---
on:
  workflow_dispatch:
permissions:
  contents: read
  issues: read
  pull-requests: read
  copilot-requests: write
engine: copilot
tools:
  github:
    mode: remote
    allowed: [get_repository, list_issues]
safe-outputs:
  create-issue:
    samples:
      - title: "GitHub remote MCP passed"
        body: "The hosted GitHub MCP server returned repository information."
timeout-minutes: 5
---

Using only the remote GitHub MCP server, get information about
`githubnext/gh-aw-test` and list three open issues. Create one issue reporting
the repository name and the three issue numbers.