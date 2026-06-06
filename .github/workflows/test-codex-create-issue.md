---
on:
  workflow_dispatch:

permissions: read-all

engine: 
  id: codex

safe-outputs:
  create-issue:
    title-prefix: "[codex-test] "
    labels: [codex, automation, haiku]
    # min: 1
    samples:
      - title: "Hello from Codex"
        body: |
          World

          A haiku for the test:
            code flows like water
            automated by AI dreams
            tests pass silently
---

Create an issue in repository ${{ github.repository }} with title "Hello from Codex" and body "World"

Add a haiku about GitHub Actions and AI to the issue body.