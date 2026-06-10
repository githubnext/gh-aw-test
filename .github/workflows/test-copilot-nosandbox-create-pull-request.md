---
on:
  workflow_dispatch:

strict: false

permissions: read-all

engine: 
  id: copilot

features:
  dangerously-disable-sandbox-agent: "test environment with no useful secrets or information"

sandbox:
  agent: false

safe-outputs:
  create-pull-request:
    title-prefix: "[copilot-nosandbox-test-single-pr] "
    labels: [copilot, automation, bot, nosandbox]
    samples:
      - title: "Multi-commit test from Copilot (No Sandbox)"
        body: "This pull request was created by Copilot without sandbox protection to test multi-commit functionality."
        branch: "gh-aw-sample-copilot-nosandbox-multi-commit"
        patch: |
          diff --git a/README-nosandbox-test.md b/README-nosandbox-test.md
          new file mode 100644
          --- /dev/null
          +++ b/README-nosandbox-test.md
          @@ -0,0 +1,3 @@
          +# Test Project (No Sandbox)
          +
          +This is a test project created by Copilot without sandbox to test multi-commit pull requests.
  threat-detection: false  # Disable threat detection
---

# Test Copilot Create Pull Request (No Sandbox)

This test workflow specifically tests multi-commit functionality in create-pull-request without sandbox protection.

**IMPORTANT: Create multiple separate commits for this test case**

1. **First commit**: Create a file "README-nosandbox-test.md" with content:
   ```markdown
   # Test Project (No Sandbox)
   
   This is a test project created by Copilot to test multi-commit pull requests without sandbox protection.
   
   Created at: {{ current timestamp }}
   ```

2. **Second commit**: Create a JavaScript script "test-script-nosandbox.js" with:
   ```javascript
   #!/usr/bin/env node
   function hello() {
       console.log("Hello from Copilot multi-commit test (No Sandbox)!");
   }
   
   if (require.main === module) {
       hello();
   }
   ```

3. **Third commit**: Create a configuration file "config-nosandbox.json" with:
   ```json
   {
       "test": true,
       "engine": "copilot",
       "sandbox": false,
       "purpose": "multi-commit-test-nosandbox",
       "timestamp": "{{ current timestamp }}"
   }
   ```

Then create a pull request with title "Test Copilot PR (No Sandbox)" and the body:
- Describe the changes
- Note that this tests no-sandbox mode
- Add a haiku about freedom from sandbox constraints

Include all three commits in the pull request.
