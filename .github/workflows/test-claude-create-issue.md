---
on:
  workflow_dispatch:

  roles: ["admin", "maintainer", "write"]

permissions: read-all

engine: 
  id: claude

safe-outputs:
  create-issue:
    title-prefix: "[claude-test] "
    labels: [claude, automation, haiku]
    # min: 1
    samples:
      - title: "Hello from Claude"
        body: |
          World

          A haiku for the test:
            silent agent runs
            replay drives every output
            green ticks bloom in CI
---

Create an issue in repository ${{ github.repository }} with title "Hello from Claude" and body "World"

Add a haiku about GitHub Actions and AI to the issue body.