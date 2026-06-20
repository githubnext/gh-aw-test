---
on:
  workflow_dispatch:
    inputs:
      pull_request_number:
        description: 'Pull request number'
        required: true
        type: number

permissions: read-all

checkout:
  - repository: githubnext/gh-aw-side-repo
    token: ${{ secrets.TEMP_USER_PAT || secrets.GH_AW_TEST_PAT }}
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
    target: ${{ inputs.pull_request_number }}
    target-repo: 'githubnext/gh-aw-side-repo'
    allowed-repos: ['githubnext/gh-aw-side-repo']
    samples:
      - message: "Multi-commit test push from Copilot in side repo"
        pull_request_number: "${{ github.event.inputs.pull_request_number }}"
        repo: "githubnext/gh-aw-side-repo"
        patch: |
          diff --git a/README-copilot-siderepo-test.md b/README-copilot-siderepo-test.md
          new file mode 100644
          --- /dev/null
          +++ b/README-copilot-siderepo-test.md
          @@ -0,0 +1,3 @@
          +# Copilot Push-to-Branch Test (Side Repo)
          +
          +This file was created by Copilot in the side repository.
---

1. Checkout the pull request branch for PR #${{ inputs.pull_request_number }} in repository githubnext/gh-aw-side-repo
2. Create a file "README-copilot-test.md" with content:
   ```markdown
   # Copilot Push Test
   
   This file was created by pushing directly to the PR branch.
   ```
3. Create a file "copilot-script.py" with content:
   ```python
   print("Hello from Copilot push test")
   ```
4. Commit both files in separate commits
5. Push the commits to the pull request branch for PR #${{ inputs.pull_request_number }}
