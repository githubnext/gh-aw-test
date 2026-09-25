---
on:
  slash_command:
    name: test-claude-push-to-pull-request-branch
  reaction: eyes

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
  push-to-pull-request-branch:
    samples:
      - message: "Multi-commit test push from Claude"
        patch: |
          diff --git a/README-claude-test.md b/README-claude-test.md
          new file mode 100644
          --- /dev/null
          +++ b/README-claude-test.md
          @@ -0,0 +1,3 @@
          +# Claude Push-to-Branch Multi-Commit Test
          +
          +This file was created by the Claude agentic workflow under the samples replay driver.
---

# Test Claude Push to Branch

This test workflow specifically tests multi-commit functionality in push-to-pull-request-branch.

**IMPORTANT: Create multiple separate commits for this test case**

0. Checkout the branch for the pull request #${{ github.event.issue.number }}

1. **First commit**: Create a file called "README-claude-test.md" with:
   ```markdown
   # Claude Push-to-Branch Multi-Commit Test
   
   This file was created by the Claude agentic workflow to test the multi-commit push-to-pull-request-branch functionality.
   
   Created at: {{ current timestamp }}
   
   ## Purpose
   This test verifies that multiple commits are properly applied when using push-to-pull-request-branch.
   ```

2. **Second commit**: Create a Python script called "claude-script.py" with:
   ```python
   #!/usr/bin/env python3
   """
   Multi-commit test script created by Claude agentic workflow
   """
   
   import datetime
   
   def main():
       print("Hello from Claude agentic workflow!")
       print(f"Current time: {datetime.datetime.now()}")
       print("This script was created to test multi-commit push-to-pull-request-branch functionality.")
       print("This is commit #2 in the multi-commit test.")
   
   if __name__ == "__main__":
       main()
   ```

Push these changes to the branch for the pull request #${{ github.event.issue.number }}

