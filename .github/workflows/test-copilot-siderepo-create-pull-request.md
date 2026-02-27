---
on:
  workflow_dispatch:

permissions:
  contents: read

engine: 
  id: copilot

safe-outputs:
  create-pull-request:
    title-prefix: "[copilot-test] "
    labels: [copilot, automation, bot]
    target-repo: 'githubnext/gh-aw-side-repo'
    allowed-repos: ['githubnext/gh-aw-side-repo']
    github-token: ${{ secrets.TEMP_USER_PAT }}
---

# Test Copilot Create Pull Request (Side Repo)

This test workflow specifically tests multi-commit functionality in create-pull-request in the side repository.

**IMPORTANT: Create multiple separate commits for this test case**

1. **First commit**: Create a file "README-test.md" with content:
   ```markdown
   # Test Project
   
   This is a test project created by Copilot to test multi-commit pull requests.
   
   Created at: {{ current timestamp }}
   ```

2. **Second commit**: Create a JavaScript script "test-script.js" with:
   ```javascript
   #!/usr/bin/env node
   function hello() {
       console.log("Hello from Copilot multi-commit test!");
   }
   
   if (require.main === module) {
       hello();
   }
   ```

3. **Third commit**: Create a configuration file "config.json" with:
   ```json
   {
       "test": true,
       "engine": "copilot",
       "purpose": "multi-commit-test",
       "repository": "githubnext/gh-aw-side-repo",
       "timestamp": "{{ current timestamp }}"
   }
   ```

Create a pull request in the repository githubnext/gh-aw-side-repo with title "[copilot-test] Multi-Commit PR Test" targeting the main branch.

Make sure all three commits are separate and properly attributed. Include a summary of all changes in the PR description.
