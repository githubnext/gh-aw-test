---
on:
  workflow_dispatch:

engine:
  id: claude
safe-outputs:
  create-issue:
    title-prefix: "[claude-test] "
    labels: [claude, automation, haiku]
    min: 1
  create-pull-request:
    title-prefix: "[claude-test] "
    labels: [claude, automation, bot]
    min: 1
---

Create an issue with title "Hello from Claude (multi)" and body "World"

Create a pull request with one commit - Create a file "README-test.md" with content:
   ```markdown
   # Test Project
   ```

Create a pull request with title "Test from Claude (multi)" and body "This pull request was created by Claude to test multi-output functionality in agentic workflows."