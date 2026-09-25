---
on:
  workflow_dispatch:
permissions:
  contents: read
  actions: read
  copilot-requests: write
engine: copilot
safe-outputs:
  env:
    JIRA_BASE_URL: ${{ vars.JIRA_BASE_URL }}
    JIRA_PROJECT_KEY: ${{ vars.JIRA_PROJECT_KEY }}
    JIRA_USER_EMAIL: ${{ secrets.JIRA_USER_EMAIL }}
    JIRA_API_TOKEN: ${{ secrets.JIRA_API_TOKEN }}
  jira-create-issue:
    max: 1
timeout-minutes: 5
---

Create one Jira Task in project `${{ env.JIRA_PROJECT_KEY }}` titled "gh-aw E2E Jira safe-output test" with a short description identifying this workflow run.