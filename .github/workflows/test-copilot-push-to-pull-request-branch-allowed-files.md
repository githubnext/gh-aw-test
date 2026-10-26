---
on:
  workflow_dispatch:
    inputs:
      branch_name:
        description: Pull request branch name
        required: true
        type: string
      pull_request_number:
        description: Pull request number
        required: true
        type: number
permissions:
  contents: read
  pull-requests: read
  copilot-requests: write
engine:
  id: copilot
safe-outputs:
  push-to-pull-request-branch:
    branch: ${{ inputs.branch_name }}
    target: ${{ inputs.pull_request_number }}
    allowed-files: [".changeset/**"]
    samples:
      - message: Add allowed changeset
        patch: |
          diff --git a/.changeset/phase-c-allowed.md b/.changeset/phase-c-allowed.md
          new file mode 100644
          --- /dev/null
          +++ b/.changeset/phase-c-allowed.md
          @@ -0,0 +1 @@
          +GH_AW_ALLOWED_FILES_AGENT_COMMIT_E2E
---

Create `.changeset/phase-c-allowed.md` containing `GH_AW_ALLOWED_FILES_AGENT_COMMIT_E2E` and push it to the supplied pull request branch.