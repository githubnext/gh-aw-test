---
on:
  workflow_dispatch:
  roles: ["admin", "maintainer", "write"]

strict: false


permissions: read-all

engine: 
  id: claude

sandbox:
  agent: false

safe-outputs:
  create-issue:
    title-prefix: "[claude-nosandbox-test] "
    labels: [claude, automation, haiku, nosandbox]
    # min: 1
---

Create an issue in repository ${{ github.repository }} with title "Hello from Claude (No Sandbox)" and body "World"

Add a haiku about GitHub Actions and AI to the issue body.
