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
engine: copilot
safe-outputs:
  update-project:
    max: 1
    project: https://github.com/orgs/githubnext/projects/1
    github-token: ${{ secrets.GH_AW_PROJECT_GITHUB_TOKEN }}
timeout-minutes: 5
---

Update issue #${{ inputs.issue_number }} in the configured project by setting its Status field to "In Progress".