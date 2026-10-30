---
on:
  workflow_dispatch:
permissions:
  actions: read
  contents: read
  issues: read
  copilot-requests: write
engine:
  id: copilot
max-daily-ai-credits:
  value: 10000
  continue-on-error: true
safe-outputs:
  create-issue:
    title-prefix: "[daily-credits-warning] "
    samples:
      - title: Warning mode passed
        body: Daily AI credits warning mode allowed the agent to continue.
---

Create one issue titled `Warning mode passed` with body `Daily AI credits warning mode allowed the agent to continue.`