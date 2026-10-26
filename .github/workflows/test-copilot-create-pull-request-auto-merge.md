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
    title-prefix: "[auto-merge-squash] "
    labels: [copilot, automation]
    auto-merge: squash
    samples:
      - title: Enable squash auto-merge
        body: Verifies the explicit squash auto-merge strategy.
        branch: gh-aw-sample-auto-merge-squash
        patch: |
          diff --git a/phase-b-auto-merge.txt b/phase-b-auto-merge.txt
          new file mode 100644
          --- /dev/null
          +++ b/phase-b-auto-merge.txt
          @@ -0,0 +1 @@
          +GH_AW_AUTO_MERGE_SQUASH_E2E
---

Create one pull request with the title `Enable squash auto-merge` and the supplied file change.