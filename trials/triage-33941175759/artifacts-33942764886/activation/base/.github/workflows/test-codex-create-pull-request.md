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
  id: codex

safe-outputs:
  create-pull-request:
    title-prefix: "[codex-test-single-pr] "
    labels: [codex, automation, bot]
    samples:
      - title: "Multi-commit test from Codex"
        body: "This pull request was created by Codex to test multi-commit functionality in agentic workflows."
        branch: "gh-aw-sample-codex-multi-commit"
        patch: |
          diff --git a/README-test.md b/README-test.md
          new file mode 100644
          --- /dev/null
          +++ b/README-test.md
          @@ -0,0 +1,3 @@
          +# Test Project
          +
          +This is a test project created by Codex to test multi-commit pull requests.
---

# Test Codex Create Pull Request

This test workflow specifically tests multi-commit functionality in create-pull-request.

**IMPORTANT: Create multiple separate commits for this test case**

1. **First commit**: Create a file "README-test.md" with content:
   ```markdown
   # Test Project
   
   This is a test project created by Codex to test multi-commit pull requests.
   
   Created at: {{ current timestamp }}
   ```

2. **Second commit**: Create a JavaScript script "test-script.js" with:
   ```javascript
   #!/usr/bin/env node
   function hello() {
       console.log("Hello from Codex multi-commit test!");
   }
   
   if (require.main === module) {
       hello();
   }
   ```

3. **Third commit**: Create a configuration file "config.json" with:
   ```json
   {
       "test": true,
       "engine": "codex",
       "purpose": "multi-commit-test",
       "timestamp": "{{ current timestamp }}"
   }
   ```

4. **Fourth commit**: Create a log file "test.log" containing the current time. This is just a log file.

Create a pull request with title "Multi-commit test from Codex" and body:
```markdown
# Multi-Commit Test Pull Request

This PR was created by Codex to test the multi-commit functionality in agentic workflows.

## Changes Made

This PR contains exactly 4 commits:
1. Added README-test.md with project description
2. Added test-script.js with JavaScript hello function
3. Added config.json with test configuration
4. Added test.log with timestamp

Each change was made in a separate commit to test that `git am` properly applies all commits from the patch file, not just the first one.

## Haiku about Multi-Commits

Git commits aligned,  
Each change builds upon the last—  
Patch preserves them all.
```