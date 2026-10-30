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
checkout:
  - ref: ${{ inputs.branch_name }}
    fetch-depth: 0
engine:
  id: copilot
safe-outputs:
  push-to-pull-request-branch:
    branch: ${{ inputs.branch_name }}
    target: ${{ inputs.pull_request_number }}
    fallback-as-pull-request: false
    samples:
      - message: Push without fallback
        patch: |
          diff --git a/phase-b-no-fallback.txt b/phase-b-no-fallback.txt
          new file mode 100644
          --- /dev/null
          +++ b/phase-b-no-fallback.txt
          @@ -0,0 +1 @@
          +GH_AW_PUSH_NO_FALLBACK_E2E
---

Create `phase-b-no-fallback.txt` containing `GH_AW_PUSH_NO_FALLBACK_E2E` and push it to the supplied pull request branch.