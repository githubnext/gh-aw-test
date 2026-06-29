---
on:
  workflow_dispatch:
    inputs:
      pull_request_number:
        description: 'Pull request number'
        required: true
        type: number

permissions:
  issues: read
  pull-requests: read
  actions: read
  contents: read
  discussions: read
  copilot-requests: write

engine: 
  id: copilot

safe-outputs:
  push-to-pull-request-branch:
    target: ${{ inputs.pull_request_number }}
    allowed-files:
      - "*.md"
    samples:
      - message: "Dispatch-triggered push test with allowed-files from Copilot"
        pull_request_number: "${{ github.event.inputs.pull_request_number }}"
        patch: |
          diff --git a/README-copilot-allowed-files-test.md b/README-copilot-allowed-files-test.md
          new file mode 100644
          --- /dev/null
          +++ b/README-copilot-allowed-files-test.md
          @@ -0,0 +1,3 @@
          +# Copilot Push-to-Branch Test (Allowed Files)
          +
          +This file was created by the Copilot agentic workflow to test the allowed-files filter.
---

# Test Copilot Push to Branch (Allowed Files)

This test exercises `push-to-pull-request-branch` with `allowed-files: ["*.md"]` triggered via
`workflow_dispatch`, verifying that the allowed-files configuration restricts pushes to Markdown
files only.

1. Checkout the branch for PR #${{ inputs.pull_request_number }}
2. Create a file "README-copilot-allowed-files-test.md" with content:
   ```markdown
   # Copilot Push-to-Branch Test (Allowed Files)

   This file was created by the Copilot agentic workflow to test the allowed-files filter.
   ```
3. Commit the file
4. Push the commit to the pull request branch for PR #${{ inputs.pull_request_number }}
