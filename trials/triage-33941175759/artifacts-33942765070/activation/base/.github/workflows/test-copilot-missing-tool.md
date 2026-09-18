---
on:
  workflow_dispatch:

permissions:
  issues: read
  pull-requests: read
  actions: read
  contents: read
  discussions: read
  copilot-requests: write

engine:
  id: copilot

safe-outputs:
  missing-tool:
    samples:
      - tool: "hypothetical-unavailable-tool"
        reason: "The tool is intentionally unavailable for this E2E test."
        alternatives: "Continue without calling the tool."
---

Emit a `missing_tool` safe output for "hypothetical-unavailable-tool" with reason "The tool is intentionally unavailable for this E2E test." and alternatives "Continue without calling the tool.".