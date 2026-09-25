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

tools:
  github:
    # The GitHub tools must be authorized to read across-repo 
    github-token: ${{ secrets.TEMP_USER_PAT || secrets.GH_AW_TEST_PAT }}

# Regression test for gh-aw "Failed to pin branch ''" / git "dubious ownership":
# check out the cross-repository side repo into a SUBDIRECTORY ("github") instead
# of the workspace root. The git-running safe-output handlers must mark that
# subdirectory as a safe.directory before running `git rev-parse` to pin the
# branch, otherwise pinning aborts with an empty SHA.
checkout:
  - repository: githubnext/gh-aw-side-repo
    token: ${{ secrets.TEMP_USER_PAT || secrets.GH_AW_TEST_PAT }}
    path: github                 # cross-repo checkout into ${GITHUB_WORKSPACE}/github
    fetch: ["*"]                 # fetch all open PR refs after checkout
    fetch-depth: 0               # fetch full history to ensure we can see all commits and PR details

safe-outputs:
  create-pull-request:
    title-prefix: "[copilot-test-subdir-pr] "
    labels: [copilot, automation, bot]
    target-repo: 'githubnext/gh-aw-side-repo'
    allowed-repos: ['githubnext/gh-aw-side-repo']
    github-token: ${{ secrets.TEMP_USER_PAT || secrets.GH_AW_TEST_PAT }}
    samples:
      - title: "Subdirectory checkout PR test from Copilot"
        body: "This pull request was created by Copilot in the side repository that was checked out into the 'github' subdirectory, to test branch pinning under a cross-repository subdirectory checkout."
        branch: "gh-aw-sample-copilot-siderepo-subdir-pr"
        patch: |
          diff --git a/subdir-notes.md b/subdir-notes.md
          new file mode 100644
          --- /dev/null
          +++ b/subdir-notes.md
          @@ -0,0 +1,3 @@
          +# Subdirectory Checkout Test (Side Repo)
          +
          +This file was created by Copilot in a side repository checked out into a subdirectory.
---

# Test Copilot Create Pull Request — Subdirectory Side-Repo Checkout

This test workflow exercises `create-pull-request` against a side repository that
is checked out into a **subdirectory** (`${GITHUB_WORKSPACE}/github`) rather than
the workspace root. It is a regression test for the bug where git-running
safe-output handlers fail with `Failed to pin branch ''` because the subdirectory
checkout is a separate git repository that git refuses to operate on with a
"dubious ownership" error unless it has been trusted as a `safe.directory`.

Create a file "subdir-notes.md" in the side repository with content:

```markdown
# Subdirectory Checkout Test

This file was created by Copilot in a side repository checked out into the
'github' subdirectory.

Created at: {{ current timestamp }}
```

Create a pull request in the repository githubnext/gh-aw-side-repo with title
"[copilot-test] Subdirectory Side-Repo PR" targeting the main branch. Include a
short summary of the change in the PR description.
