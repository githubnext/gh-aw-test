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
  id: claude

safe-outputs:
  create-pull-request:
    title-prefix: "[claude-test-two-prs] "
    labels: [claude, automation, bot]
    max: 2
    samples:
      - title: "Feature A from Claude"
        body: "Adds Feature A as part of the two-PR test."
        branch: "gh-aw-sample-claude-feature-a"
        patch: |
          diff --git a/feature-a/notes.md b/feature-a/notes.md
          new file mode 100644
          --- /dev/null
          +++ b/feature-a/notes.md
          @@ -0,0 +1,3 @@
          +# Feature A
          +
          +Created by Claude under the samples replay driver.
      - title: "Feature B from Claude"
        body: "Adds Feature B as part of the two-PR test."
        branch: "gh-aw-sample-claude-feature-b"
        patch: |
          diff --git a/feature-b/notes.md b/feature-b/notes.md
          new file mode 100644
          --- /dev/null
          +++ b/feature-b/notes.md
          @@ -0,0 +1,3 @@
          +# Feature B
          +
          +Created by Claude under the samples replay driver.
---

# Test Claude Create Two Pull Requests

This test workflow specifically tests creating two independent pull requests.

**IMPORTANT: Create TWO separate pull requests for this test case**

## First Pull Request

1. **First commit**: Create a file "feature-a/notes.md" with content:
   ```markdown
   # Feature A
   
   This is Feature A created by Claude to test multi-PR functionality.
   
   Created at: {{ current timestamp }}
   ```

2. **Second commit**: Create a Python script "feature-a/script.py" with:
   ```python
   #!/usr/bin/env python3
   def feature_a():
       print("Hello from Feature A!")
       
   if __name__ == "__main__":
       feature_a()
   ```

Create the first pull request with title "Feature A: Multi-PR test" and body "This is the first PR in a multi-PR test by Claude."

## Second Pull Request

1. **First commit**: Create a file "feature-b/notes.md" with content:
   ```markdown
   # Feature B
   
   This is Feature B created by Claude to test multi-PR functionality.
   
   Created at: {{ current timestamp }}
   ```

2. **Second commit**: Create a JavaScript script "feature-b/script.js" with:
   ```javascript
   #!/usr/bin/env node
   function featureB() {
       console.log("Hello from Feature B!");
   }
   
   if (require.main === module) {
       featureB();
   }
   ```

Create the second pull request with title "Feature B: Multi-PR test" and body "This is the second PR in a multi-PR test by Claude."
