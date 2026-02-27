---
on:
  workflow_dispatch:
    inputs:
      pull_request_number:
        description: 'Pull request number'
        required: true
        type: number

permissions: read-all

engine: 
  id: copilot

tools:
  github:
    # The GitHub tools must be authorized to read across-repo 
    github-token: ${{ secrets.TEMP_USER_PAT }}

safe-outputs:
  github-token: ${{ secrets.TEMP_USER_PAT }}
  push-to-pull-request-branch:
    # target-repo: 'githubnext/gh-aw-side-repo'
    # allowed-repos: ['githubnext/gh-aw-side-repo']
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
