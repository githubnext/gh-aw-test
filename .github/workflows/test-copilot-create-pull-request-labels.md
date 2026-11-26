---
on:
  workflow_dispatch:
permissions:
  contents: read
  pull-requests: read
  copilot-requests: write
engine:
  id: copilot
safe-outputs:
  create-pull-request:
    title-prefix: "[pr-labels] "
    labels: [copilot, automation, bot]
    samples:
      - title: Verify pull request labels
        body: Verifies array-valued label extraction.
        branch: gh-aw-sample-pr-labels
        patch: |
          diff --git a/phase-b-pr-labels.txt b/phase-b-pr-labels.txt
          new file mode 100644
          --- /dev/null
          +++ b/phase-b-pr-labels.txt
          @@ -0,0 +1 @@
          +GH_AW_CREATE_PR_LABELS_E2E
---

Create one pull request titled `Verify pull request labels` with the supplied file change.