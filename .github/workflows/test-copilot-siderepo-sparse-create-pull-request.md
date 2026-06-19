---
on:
  workflow_dispatch:

permissions: read-all

engine: 
  id: copilot

tools:
  github:
    # The GitHub tools must be authorized to read across-repo 
    github-token: ${{ secrets.TEMP_USER_PAT }}

checkout:
  - repository: githubnext/gh-aw-side-repo
    token: ${{ secrets.TEMP_USER_PAT }}
    fetch-depth: 1                # shallow clone — only the tip commit
    sparse-checkout: |
      src/
      docs/
    # data/, scripts/, tests/ are intentionally excluded to keep the
    # checkout small and exercise the sparse-checkout path.

safe-outputs:
  create-pull-request:
    title-prefix: "[copilot-test-sparse-pr] "
    labels: [copilot, automation, bot]
    target-repo: 'githubnext/gh-aw-side-repo'
    allowed-repos: ['githubnext/gh-aw-side-repo']
    github-token: ${{ secrets.TEMP_USER_PAT }}
    samples:
      - title: "Shallow sparse-checkout PR test from Copilot"
        body: "This pull request was created by Copilot using a depth-1 sparse checkout of src/ and docs/ in the side repository."
        branch: "gh-aw-sample-copilot-siderepo-sparse-pr"
        patch: |
          diff --git a/src/sparse-pr-test.py b/src/sparse-pr-test.py
          new file mode 100644
          --- /dev/null
          +++ b/src/sparse-pr-test.py
          @@ -0,0 +1,3 @@
          +# Added by Copilot via shallow sparse-checkout create-pull-request test
          +
          +print("sparse checkout create-pr test")
---

# Test Copilot Create Pull Request — Shallow + Sparse Checkout (Side Repo)

This test validates `create-pull-request` when the side repository is checked
out with:
- `fetch-depth: 1` — a depth-1 shallow clone (only the tip commit, no full history)
- `sparse-checkout: src/ docs/` — only the `src/` and `docs/` subtrees are
  present on disk (`data/`, `scripts/`, `tests/` are excluded)

1. Create a file "src/sparse-pr-test.py" in the side repository with content:
   ```python
   # Added by Copilot via shallow sparse-checkout create-pull-request test

   print("sparse checkout create-pr test")
   ```

2. Create a pull request in the repository githubnext/gh-aw-side-repo with
   title "[copilot-test-sparse] Shallow Sparse-Checkout PR Test" targeting
   the main branch.

Include a brief description noting that the PR was created from a depth-1 sparse
checkout that only contained `src/` and `docs/`.
