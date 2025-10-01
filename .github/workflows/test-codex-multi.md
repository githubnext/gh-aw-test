---
on:
  workflow_dispatch:
concurrency:
  group: "gh-aw-${{ github.workflow }}-${{ github.run_id }}"
safe-outputs:
  create-issue:
    title-prefix: "[codex-test] "
    labels: [codex, automation, haiku]
    min: 1
  create-pull-request:
    title-prefix: "[codex-test] "
    labels: [codex, automation, bot]
---

Create an issue with title "Hello from Codex (multi)" and body "World"

Create a pull request with one commit - Create a file "README-test.md" with content:
   ```markdown
   # Test Project
   ```

Create a pull request with title "Test from Codex (multi)" and body "This pull request was created by Codex to test multi-output functionality in agentic workflows."
