---
on:
  workflow_dispatch:

strict: false

permissions: read-all

engine: 
  id: copilot

sandbox:
  agent: false

safe-outputs:
  create-pull-request:
    title-prefix: "[copilot-nosandbox-test] "
    labels: [copilot, automation, bot, nosandbox]
    #max: 2
---

# Test Copilot Create Two Pull Requests (No Sandbox)

This test workflow specifically tests creating two independent pull requests without sandbox protection.

**IMPORTANT: Create TWO separate pull requests for this test case**

## First Pull Request

1. **First commit**: Create a file "feature-a/README-nosandbox.md" with content:
   ```markdown
   # Feature A (No Sandbox)
   
   This is Feature A created by Copilot to test multi-PR functionality without sandbox protection.
   
   Created at: {{ current timestamp }}
   ```

2. **Second commit**: Create a Python script "feature-a/script-nosandbox.py" with:
   ```python
   #!/usr/bin/env python3
   def feature_a():
       print("Hello from Feature A (No Sandbox)!")
       
   if __name__ == "__main__":
       feature_a()
   ```

Create the first pull request with title "Feature A: Multi-PR test (No Sandbox)" and body "This is the first PR in a multi-PR test by Copilot without sandbox protection."

## Second Pull Request

1. **First commit**: Create a file "feature-b/README-nosandbox.md" with content:
   ```markdown
   # Feature B (No Sandbox)
   
   This is Feature B created by Copilot to test multi-PR functionality without sandbox protection.
   
   Created at: {{ current timestamp }}
   ```

2. **Second commit**: Create a JavaScript script "feature-b/script-nosandbox.js" with:
   ```javascript
   #!/usr/bin/env node
   function featureB() {
       console.log("Hello from Feature B (No Sandbox)!");
   }
   
   if (require.main === module) {
       featureB();
   }
   ```

Create the second pull request with title "Feature B: Multi-PR test (No Sandbox)" and body "This is the second PR in a multi-PR test by Copilot without sandbox protection."
