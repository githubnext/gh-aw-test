---
on:
  workflow_dispatch:

permissions:
  contents: read

engine: 
  id: copilot

tools:
  github:
    # The GitHub tools must be authorized to read across-repo 
    github-token: ${{ secrets.TEMP_USER_PAT }}

safe-outputs:
  create-pull-request:
    title-prefix: "[copilot-test] "
    labels: [copilot, automation, bot]
    target-repo: 'githubnext/gh-aw-side-repo'
    allowed-repos: ['githubnext/gh-aw-side-repo']
    github-token: ${{ secrets.TEMP_USER_PAT }}
    # max: 2
---

# Test Copilot Create Two Pull Requests (Side Repo)

This workflow creates TWO separate pull requests in the side repository to test the max constraint.

## Pull Request 1: Feature A
Create a pull request with title "[copilot-test] Feature A - Documentation Updates" containing:
1. Create file "DOC-A.md" with:
   ```markdown
   # Feature A Documentation
   
   This is documentation for feature A.
   ```
2. Create file "feature-a.py" with:
   ```python
   def feature_a():
       print("Feature A implementation")
   ```

## Pull Request 2: Feature B
Create a second pull request with title "[copilot-test] Feature B - Script Utilities" containing:
1. Create file "DOC-B.md" with:
   ```markdown
   # Feature B Documentation
   
   This is documentation for feature B.
   ```
2. Create file "feature-b.js" with:
   ```javascript
   function featureB() {
       console.log("Feature B implementation");
   }
   ```

Both pull requests should target the main branch in repository githubnext/gh-aw-side-repo.
