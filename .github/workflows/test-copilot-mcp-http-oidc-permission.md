---
on:
  workflow_dispatch:
permissions:
  contents: read
  id-token: write
  issues: read
engine: copilot
network:
  allowed: [defaults, oidc-mcp.example.test]
mcp-servers:
  oidc-test:
    type: http
    url: https://oidc-mcp.example.test/mcp
    auth:
      type: github-oidc
      audience: https://oidc-mcp.example.test
    allowed: [ping]
safe-outputs:
  create-issue:
    samples:
      - title: "OIDC HTTP MCP passed"
        body: "The HTTP MCP server accepted GitHub OIDC authentication."
timeout-minutes: 5
---

Call the `ping` tool on the OIDC-authenticated HTTP MCP server, then create one
issue reporting its response.