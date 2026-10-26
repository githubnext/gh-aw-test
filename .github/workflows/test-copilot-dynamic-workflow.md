---
on:
  workflow_dispatch:
permissions:
  contents: read
  copilot-requests: write
engine:
  id: copilot
  dynamic-workflows: true
  args: ["--experimental"]
timeout-minutes: 5
---

Run the `phase-a-dynamic-workflow` extension workflow with marker `GH_AW_DYNAMIC_WORKFLOW_E2E`. Report its returned JSON object exactly.