---
on:
  workflow_dispatch:
    inputs:
      pull_request_number:
        description: 'Pull request number'
        required: true
        type: number

permissions: read-all

engine:
  id: copilot

safe-outputs:
  push-to-pull-request-branch:
    target: ${{ inputs.pull_request_number }}
    samples:
      - message: "Dispatch-triggered multi-file push test from Copilot"
        pull_request_number: "${{ github.event.inputs.pull_request_number }}"
        patch: |
          diff --git a/trials/copilot-multifile-a.md b/trials/copilot-multifile-a.md
          new file mode 100644
          --- /dev/null
          +++ b/trials/copilot-multifile-a.md
          @@ -0,0 +1,3 @@
          +# Copilot Multi-file Dispatch Test A
          +
          +This file was created by the Copilot agentic workflow via workflow_dispatch.
          diff --git a/trials/copilot-multifile-b.md b/trials/copilot-multifile-b.md
          new file mode 100644
          --- /dev/null
          +++ b/trials/copilot-multifile-b.md
          @@ -0,0 +1,3 @@
          +# Copilot Multi-file Dispatch Test B
          +
          +This file was created by the Copilot agentic workflow via workflow_dispatch.
---

# Test Copilot Push to Branch (Dispatch, Multi-file)

This test exercises `push-to-pull-request-branch` triggered via `workflow_dispatch`
with a multi-file patch bundle.

1. Checkout the branch for PR #${{ inputs.pull_request_number }}
2. Create file `trials/copilot-multifile-a.md` with content:
   ```markdown
   # Copilot Multi-file Dispatch Test A

   This file was created by the Copilot agentic workflow via workflow_dispatch.
   ```
3. Create file `trials/copilot-multifile-b.md` with content:
   ```markdown
   # Copilot Multi-file Dispatch Test B

   This file was created by the Copilot agentic workflow via workflow_dispatch.
   ```
4. Commit both files in one commit
5. Push the commit to the pull request branch for PR #${{ inputs.pull_request_number }}
