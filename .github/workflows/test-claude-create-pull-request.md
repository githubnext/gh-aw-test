---
on:
  workflow_dispatch:

permissions: read-all

engine: 
  id: claude

safe-outputs:
  create-pull-request:
    title-prefix: "[claude-test-single-pr] "
    labels: [claude, automation, bot]
    samples:
      - title: "Multi-commit test from Claude"
        body: "This pull request was created by Claude to test multi-commit functionality in agentic workflows."
        branch: "gh-aw-sample-claude-multi-commit"
        patch: |
          diff --git a/README-test.md b/README-test.md
          new file mode 100644
          --- /dev/null
          +++ b/README-test.md
          @@ -0,0 +1,3 @@
          +# Test Project
          +
          +This is a test project created by Claude to test multi-commit pull requests.
---

# Test Claude Create Pull Request

This test workflow specifically tests multi-commit functionality in create-pull-request.

**IMPORTANT: Create multiple separate commits for this test case**

1. **First commit**: Create a file "README-test.md" with content:
   ```markdown
   # Test Project
   
   This is a test project created by Claude to test multi-commit pull requests.
   
   Created at: {{ current timestamp }}
   ```

2. **Second commit**: Create a Python script "test-script.py" with:
   ```python
   #!/usr/bin/env python3
   def hello():
       print("Hello from Claude multi-commit test!")
       
   if __name__ == "__main__":
       hello()
   ```

Create a pull request with title "Multi-commit test from Claude" and body "This pull request was created by Claude to test multi-commit functionality in agentic workflows."
