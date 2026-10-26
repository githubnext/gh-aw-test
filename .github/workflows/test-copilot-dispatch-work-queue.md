---
on:
  workflow_dispatch:
permissions:
  contents: read
  copilot-requests: write
tools:
  work-queue: true
safe-outputs:
  dispatch-workflow:
    workflows:
      - phase-a-work-queue-worker
    max: 1
timeout-minutes: 5
---

Submit one work item containing the marker `GH_AW_WORK_QUEUE_E2E`, assign it, and dispatch `phase-a-work-queue-worker` to process it.