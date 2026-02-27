---
on:
  slash_command:
    name: test-copilot-siderepo-push-to-pull-request-branch
  reaction: eyes

permissions: read-all

engine: 
  id: copilot

safe-outputs:
  github-token: ${{ secrets.TEMP_USER_PAT }}
  push-to-pull-request-branch:
    # target-repo: 'githubnext/gh-aw-side-repo'
    # allowed-repos: ['githubnext/gh-aw-side-repo']
---

1. Checkout the pull request branch for PR #${{ github.event.pull_request.number }} in repository githubnext/gh-aw-side-repo
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
5. Push the commits to the pull request branch for PR #${{ github.event.pull_request.number }}
