---
on:
  workflow_dispatch:

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
  create-pull-request:
    title-prefix: "[copilot-rltpr] "
    labels: [copilot, automation]
    # min: 1
    samples:
      - temporary_id: aw_rltpr
        title: "Test required-labels update from Copilot"
        body: "Initial PR body for required-labels update test."
        branch: "gh-aw-sample-copilot-rltpr"
        patch: |
          diff --git a/trials/rltpr-test.md b/trials/rltpr-test.md
          new file mode 100644
          --- /dev/null
          +++ b/trials/rltpr-test.md
          @@ -0,0 +1,3 @@
          +# Required Labels PR Test
          +
          +This file tests update-pull-request with required-labels filter.
  update-pull-request:
    required-labels: [copilot]
    title: true
    body: true
    # min: 1
    samples:
      - pull_request_number: "#aw_rltpr"
        title: "[copilot-rltpr] [UPDATED] Test required-labels update from Copilot"
        body: "This pull request was automatically updated by the Copilot agentic workflow (required-labels test)."
---

# Test Copilot Update Pull Request with Required Labels

This workflow is a regression test for gh-aw#44168, which fixed `update-pull-request`
silently ignoring `required-labels` safe-output filters at compile time.

## Steps

1. Create a pull request with temporary_id `aw_rltpr` and title "Test required-labels update from Copilot".
   Add a file `trials/rltpr-test.md` with content:
   ```markdown
   # Required Labels PR Test

   This file tests update-pull-request with required-labels filter.
   ```

2. Update that pull request (`pull_request_number: '#aw_rltpr'`) with:
   - title: "[copilot-rltpr] [UPDATED] Test required-labels update from Copilot"
   - body: "This pull request was automatically updated by the Copilot agentic workflow (required-labels test)."
