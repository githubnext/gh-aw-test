---
on:
  workflow_dispatch:
permissions:
  contents: read
  issues: read
  pull-requests: read
  copilot-requests: write
engine:
  id: copilot
checkout:
  - repository: ${{ vars.GH_AW_TEST_NO_ISSUES_REPO }}
    path: no-issues-target
    token: ${{ secrets.GH_AW_TEST_PAT }}
    fetch-depth: 0
safe-outputs:
  create-pull-request:
    title-prefix: "[issues-disabled] "
    target-repo: ${{ vars.GH_AW_TEST_NO_ISSUES_REPO }}
    allowed-repos: ${{ vars.GH_AW_TEST_NO_ISSUES_REPO }}
    github-token: ${{ secrets.GH_AW_TEST_PAT }}
    assignees: [gh-aw-e2e-user-that-does-not-exist]
    samples:
      - title: Exercise fallback with target issues disabled
        body: The invalid assignee forces fallback handling.
        branch: gh-aw-sample-issues-disabled
        patch: |
          diff --git a/phase-b-issues-disabled.txt b/phase-b-issues-disabled.txt
          new file mode 100644
          --- /dev/null
          +++ b/phase-b-issues-disabled.txt
          @@ -0,0 +1 @@
          +GH_AW_ISSUES_DISABLED_FALLBACK_E2E
---

Create one pull request titled `Exercise fallback with target issues disabled` and assign it to `gh-aw-e2e-user-that-does-not-exist`.