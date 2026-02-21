---
on:
  workflow_dispatch:

permissions: read-all

engine: 
  id: claude

safe-outputs:
  create-pull-request:
    title-prefix: "[claude-test] "
    labels: [claude, automation, bot]
    #max: 2
---

# Test Claude Create Two Pull Requests

This test workflow specifically tests creating two independent pull requests.

**IMPORTANT: Create TWO separate pull requests for this test case**

## First Pull Request

1. **First commit**: Create a file "feature-a/README.md" with content:
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

1. **First commit**: Create a file "feature-b/README.md" with content:
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
