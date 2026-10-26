---
on:
  workflow_dispatch:
permissions:
  contents: read
  pull-requests: read
  copilot-requests: write
engine:
  id: copilot
checkout:
  - repository: ${{ vars.GH_AW_TEST_SAME_ORG_HEAD_REPO }}
    path: same-org-head
    token: ${{ secrets.GH_AW_TEST_PAT }}
    fetch-depth: 0
safe-outputs:
  create-pull-request:
    title-prefix: "[same-org-fork] "
    target-repo: ${{ vars.GH_AW_TEST_SAME_ORG_BASE_REPO }}
    head-repo: ${{ vars.GH_AW_TEST_SAME_ORG_HEAD_REPO }}
    allowed-repos: ${{ vars.GH_AW_TEST_SAME_ORG_ALLOWED_REPOS }}
    github-token: ${{ secrets.GH_AW_TEST_PAT }}
    head-github-token: ${{ secrets.GH_AW_TEST_PAT }}
    samples:
      - title: Create a same-organization fork PR
        body: Verifies explicit head_repo disambiguation.
        branch: gh-aw-sample-same-org-fork
        patch: |
          diff --git a/phase-b-same-org.txt b/phase-b-same-org.txt
          new file mode 100644
          --- /dev/null
          +++ b/phase-b-same-org.txt
          @@ -0,0 +1 @@
          +GH_AW_SAME_ORG_FORK_E2E
---

Create one pull request titled `Create a same-organization fork PR` using the checked-out head repository.