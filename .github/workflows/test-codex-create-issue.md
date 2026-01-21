---
on:
  workflow_dispatch:

permissions: read

engine: 
  id: codex

safe-outputs:
  create-issue:
    title-prefix: "[codex-test] "
    labels: [codex, automation, haiku]
    # min: 1
---

Create an issue in repository ${{ github.repository }} with title "Hello from Codex" and body "World"

Add a haiku about GitHub Actions and AI to the issue body.