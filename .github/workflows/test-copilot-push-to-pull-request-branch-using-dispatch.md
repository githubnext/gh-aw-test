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
      - message: "Dispatch-triggered push test from Copilot"
        patch: |
          diff --git a/README-copilot-dispatch-test.md b/README-copilot-dispatch-test.md
          new file mode 100644
          --- /dev/null
          +++ b/README-copilot-dispatch-test.md
          @@ -0,0 +1,3 @@
          +# Copilot Push-to-Branch Test (Dispatch)
          +
          +This file was created by the Copilot agentic workflow via workflow_dispatch.
---

# Test Copilot Push to Branch (Dispatch)

This test exercises `push-to-pull-request-branch` triggered via `workflow_dispatch`
rather than a slash command, using the `target:` field to identify the pull request.

1. Checkout the branch for PR #${{ inputs.pull_request_number }}
2. Create a file "README-copilot-dispatch-test.md" with content:
   ```markdown
   # Copilot Push-to-Branch Test (Dispatch)

   This file was created by the Copilot agentic workflow via workflow_dispatch.
   ```
3. Commit the file
4. Push the commit to the pull request branch for PR #${{ inputs.pull_request_number }}
