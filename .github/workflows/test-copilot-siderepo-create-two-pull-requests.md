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

checkout:
  - repository: githubnext/gh-aw-side-repo
    token: ${{ secrets.TEMP_USER_PAT || secrets.GH_AW_TEST_PAT }}
    fetch: ["*"]
    fetch-depth: 0

safe-outputs:
  create-pull-request:
    title-prefix: "[copilot-test-two-prs] "
    labels: [copilot, automation, bot]
    target-repo: 'githubnext/gh-aw-side-repo'
    allowed-repos: ['githubnext/gh-aw-side-repo']
    github-token: ${{ secrets.TEMP_USER_PAT || secrets.GH_AW_TEST_PAT }}
    max: 2
    samples:
      - title: "Feature A from Copilot"
        body: "Adds Feature A in side repository."
        branch: "gh-aw-sample-copilot-siderepo-feature-a"
        patch: |
          diff --git a/DOC-A.md b/DOC-A.md
          new file mode 100644
          --- /dev/null
          +++ b/DOC-A.md
          @@ -0,0 +1,3 @@
          +# Feature A Documentation
          +
          +Documentation for Feature A in side repository.
      - title: "Feature B from Copilot"
        body: "Adds Feature B in side repository."
        branch: "gh-aw-sample-copilot-siderepo-feature-b"
        patch: |
          diff --git a/DOC-B.md b/DOC-B.md
          new file mode 100644
          --- /dev/null
          +++ b/DOC-B.md
          @@ -0,0 +1,3 @@
          +# Feature B Documentation
          +
          +Documentation for Feature B in side repository.

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
