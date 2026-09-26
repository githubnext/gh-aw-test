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
    allowed: [search_issues]
safe-outputs:
  create-issue:
    samples:
      - title: "Large MCP JSON payload passed"
        body: "The GitHub MCP search returned and processed a large paginated payload."
timeout-minutes: 8
---

Use the GitHub MCP `search_issues` tool to retrieve up to 100 issues from
`githubnext/gh-aw-test`, including their bodies. Process the complete JSON
response and create one issue stating the number of results and total body
characters. Do not use `gh`, `curl`, or direct GitHub API requests.