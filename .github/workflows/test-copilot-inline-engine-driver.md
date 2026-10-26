---
on:
  workflow_dispatch:
permissions:
  contents: read
  copilot-requests: write
engine:
  id: copilot
  driver:
    node: |
      process.stderr.write("GH_AW_INLINE_ENGINE_DRIVER_E2E\n");
timeout-minutes: 5
---

Report `GH_AW_INLINE_ENGINE_DRIVER_E2E` in the final response.