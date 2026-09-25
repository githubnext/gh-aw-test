---
on:
  workflow_dispatch:
permissions:
  contents: read
  actions: read
  copilot-requests: write
engine: copilot
safe-outputs:
  linear-token: ${{ secrets.LINEAR_API_KEY }}
  linear-create-issue:
    team-id: ${{ vars.LINEAR_TEAM_ID }}
    max: 1
timeout-minutes: 5
---

Create one Linear issue titled "gh-aw E2E Linear safe-output test" with a short body identifying this workflow run.