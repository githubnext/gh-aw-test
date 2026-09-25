---
on:
  workflow_dispatch:
    inputs:
      issue_number:
        description: Issue attached to the project item
        required: true
        type: number
concurrency:
  job-discriminator: ${{ github.run_id }}
permissions:
  contents: read
  issues: read
  copilot-requests: write
engine: copilot
safe-outputs:
  update-project:
    max: 1
    project: https://github.com/orgs/githubnext/projects/153
    github-token: ${{ secrets.GH_AW_TEST_PAT }}
timeout-minutes: 5
---

Update issue #${{ inputs.issue_number }} in the configured project by setting its Status field to "In Progress".