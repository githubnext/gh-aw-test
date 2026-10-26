---
on:
  workflow_dispatch:
permissions:
  contents: read
  copilot-requests: write
tools:
  startup-timeout: 15
mcp-servers:
  delayed:
    command: node
    args: [.github/fixtures/phase-a-delayed-mcp-server.mjs]
    env:
      STARTUP_DELAY_MS: "2000"
    allowed: [phase_a_marker]
timeout-minutes: 5
---

Call the `phase_a_marker` tool from the delayed MCP server and report its marker.