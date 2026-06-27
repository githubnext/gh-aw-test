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

checkout:
  - repository: githubnext/gh-aw-side-repo
    token: ${{ secrets.TEMP_USER_PAT || secrets.GH_AW_TEST_PAT }}
    fetch: ["*"]      # fetch all open PR refs after checkout
    fetch-depth: 1                # shallow clone — only the tip commit
    sparse-checkout: |
      src/
      docs/
    # data/, scripts/, tests/ are intentionally excluded to keep the
    # checkout small and exercise the sparse-checkout path.

engine: 
  id: copilot

tools:
  github:
    # The GitHub tools must be authorized to read across-repo 
    github-token: ${{ secrets.TEMP_USER_PAT || secrets.GH_AW_TEST_PAT }}

safe-outputs:
  github-token: ${{ secrets.TEMP_USER_PAT || secrets.GH_AW_TEST_PAT }}
  push-to-pull-request-branch:
    target: ${{ inputs.pull_request_number }}
    target-repo: 'githubnext/gh-aw-side-repo'
    allowed-repos: ['githubnext/gh-aw-side-repo']
    samples:
      - message: "Shallow sparse-checkout push test from Copilot"
        pull_request_number: "${{ github.event.inputs.pull_request_number }}"
        patch: |
          diff --git a/src/sparse-test.py b/src/sparse-test.py
          new file mode 100644
          --- /dev/null
          +++ b/src/sparse-test.py
          @@ -0,0 +1,3 @@
          +# Added by Copilot via shallow sparse-checkout push test
          +
          +print("sparse checkout push test")
---

# Test: Shallow + Sparse Checkout — Push to Pull Request Branch (Side Repo)

This test validates `push-to-pull-request-branch` when the side repository is
checked out with:
- `fetch-depth: 1` — a depth-1 shallow clone (only the tip commit, no full history)
- `sparse-checkout: src/ docs/` — only the `src/` and `docs/` subtrees are
  present on disk (`data/`, `scripts/`, `tests/` are excluded)

1. Checkout the pull request branch for PR #${{ inputs.pull_request_number }} in repository githubnext/gh-aw-side-repo
2. Create a file "src/sparse-test.py" with content:
   ```python
   # Added by Copilot via shallow sparse-checkout push test
   
   print("sparse checkout push test")
   ```
3. Commit the file
4. Push the commit to the pull request branch for PR #${{ inputs.pull_request_number }}
