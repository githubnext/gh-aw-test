---
on:
  slash_command:
    name: test-copilot-nosandbox-push-to-pull-request-branch
  reaction: eyes

strict: false

permissions: read-all

engine: 
  id: copilot

sandbox:
  agent: false

safe-outputs:
  push-to-pull-request-branch:
---

# Test Copilot Push to Branch (No Sandbox)

This test workflow specifically tests multi-commit functionality in push-to-pull-request-branch without sandbox protection.

**IMPORTANT: Create multiple separate commits for this test case**

0. Checkout the branch for the pull request #${{ github.event.issue.number }}

1. **First commit**: Create a file called "README-copilot-nosandbox-test.md" with:
   ```markdown
   # Copilot Push-to-Branch Multi-Commit Test (No Sandbox)
   
   This file was created by the Copilot agentic workflow to test the multi-commit push-to-pull-request-branch functionality without sandbox protection.
   
   Created at: {{ current timestamp }}
   
   ## Purpose
   This test verifies that multiple commits are properly applied when using push-to-pull-request-branch without sandbox.
   ```

2. **Second commit**: Create a Python script called "copilot-nosandbox-script.py" with:
   ```python
   #!/usr/bin/env python3
   """
   Multi-commit test script created by Copilot agentic workflow (No Sandbox)
   """
   
   import datetime
   
   def main():
       print("Hello from Copilot agentic workflow (No Sandbox)!")
       print(f"Current time: {datetime.datetime.now()}")
       print("This script was created to test multi-commit push-to-pull-request-branch functionality without sandbox.")
       print("This is commit #2 in the multi-commit test.")
   
   if __name__ == "__main__":
       main()
   ```

Push these changes to the branch for the pull request #${{ github.event.issue.number }}
