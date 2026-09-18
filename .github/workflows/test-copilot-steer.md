---
on:
  workflow_dispatch:
permissions:
  contents: read
  actions: read
  issues: read
  copilot-requests: write
engine: copilot
safe-outputs:
  steer: true
timeout-minutes: 5
---

Create a steering issue so this run can receive steering comments, then complete the task normally.