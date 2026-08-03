---
on:
  workflow_dispatch:
    inputs:
      branch_name:
        description: 'Pull request branch name'
        required: true
        type: string
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

checkout:
  - repository: githubnext/gh-aw-side-repo
    token: ${{ secrets.TEMP_USER_PAT || secrets.GH_AW_TEST_PAT }}
    path: gh-aw-side-repo        # cross-repo checkout into ${GITHUB_WORKSPACE}/gh-aw-side-repo
    fetch: ["*"]      # fetch all open PR refs after checkout
    fetch-depth: 0               # fetch full history to ensure we can see all commits and PR details

engine: 
  id: copilot

tools:
  github:
    # The GitHub tools must be authorized to read across-repo 
    github-token: ${{ secrets.TEMP_USER_PAT || secrets.GH_AW_TEST_PAT }}

safe-outputs:
  github-token: ${{ secrets.TEMP_USER_PAT || secrets.GH_AW_TEST_PAT }}
  push-to-pull-request-branch:
    branch: ${{ inputs.branch_name }}
    target: "*"
    # TODO: add repo: "githubnext/gh-aw-side-repo" once github/gh-aw#49813 lands
    # (explicit repo field disambiguates wildcard target in multi-repo workflows)
    target-repo: 'githubnext/gh-aw-side-repo'
    allowed-repos: ['githubnext/gh-aw-side-repo']
    samples:
      - message: "Wildcard repo push test from Copilot in side repo"
        patch: |
          diff --git a/README-copilot-wildcard-repo-test.md b/README-copilot-wildcard-repo-test.md
          new file mode 100644
          --- /dev/null
          +++ b/README-copilot-wildcard-repo-test.md
          @@ -0,0 +1,3 @@
          +# Copilot Push-to-Branch Test (Wildcard Repo)
          +
          +This file was created by Copilot to test wildcard target with explicit repo disambiguation.
---

# Test Copilot Push to Pull Request Branch (Wildcard Repo, Side Repo)

This test exercises `push-to-pull-request-branch` with `target: "*"` and an explicit
`repo: githubnext/gh-aw-side-repo` field, which disambiguates the wildcard target to use
the side-repo checkout rather than `GITHUB_WORKSPACE`.

1. Checkout branch "${{ inputs.branch_name }}" for PR #${{ inputs.pull_request_number }} in repository githubnext/gh-aw-side-repo
2. Create a file "README-copilot-wildcard-repo-test.md" with content:
   ```markdown
   # Copilot Push-to-Branch Test (Wildcard Repo)
   
   This file was created by Copilot to test wildcard target with explicit repo disambiguation.
   ```
3. Commit the file
4. Push the commit to branch "${{ inputs.branch_name }}" for PR #${{ inputs.pull_request_number }} in repository githubnext/gh-aw-side-repo
