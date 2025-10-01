---
on:
  command:
    name: test-copilot-push-to-pull-request-branch
  reaction: eyes

engine: 
  id: copilot

safe-outputs:
  push-to-pull-request-branch:
---

# Test Copilot Push to Branch

This test workflow specifically tests multi-commit functionality in push-to-pull-request-branch.

**IMPORTANT: Create multiple separate commits for this test case**

0. Checkout the branch for the pull request #${{ github.event.issue.number }}

1. **First commit**: Create a file called "README-copilot-test.md" with:
   ```markdown
   # Copilot Push-to-Branch Multi-Commit Test
   
   This file was created by the Copilot agentic workflow to test the multi-commit push-to-pull-request-branch functionality.
   
   Created at: {{ current timestamp }}
   
   ## Purpose
   This test verifies that multiple commits are properly applied when using push-to-pull-request-branch.
   ```

2. **Second commit**: Create a Python script called "copilot-script.py" with:
   ```python
   #!/usr/bin/env python3
   """
   Multi-commit test script created by Copilot agentic workflow
   """
   
   import datetime
   
   def main():
       print("Hello from Copilot agentic workflow!")
       print(f"Current time: {datetime.datetime.now()}")
       print("This script was created to test multi-commit push-to-pull-request-branch functionality.")
       print("This is commit #2 in the multi-commit test.")
   
   if __name__ == "__main__":
       main()
   ```

Push these changes to the branch for the pull request #${{ github.event.issue.number }}