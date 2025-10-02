---
on:
  workflow_dispatch:
concurrency:
  group: "gh-aw-${{ github.workflow }}-${{ github.run_id }}"
engine:
  id: copilot
safe-outputs:
  create-issue:
    title-prefix: "[copilot-test] "
    labels: [copilot, automation, haiku]
    min: 1
  create-pull-request:
    title-prefix: "[copilot-test] "
    labels: [copilot, automation, bot]
---

Create an issue in repository ${{ github.repository }} with title "Hello from Copilot (multi)" and body "World"

Create a pull request with one commit - Create a file "README-test.md" with content:
   ```markdown
   # Test Project
   ```

Create a pull request with title "Test from Copilot (multi)" and body "This pull request was created by Copilot to test multi-output functionality in agentic workflows."