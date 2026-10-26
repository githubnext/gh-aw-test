---
on:
  workflow_dispatch:
permissions:
  contents: read
  copilot-requests: write
tools:
  work-queue:
    worker: true
    require-assignment: true
timeout-minutes: 5
---

Read the assigned work item and complete it. The expected task is to confirm the marker `GH_AW_WORK_QUEUE_E2E` in your final response.