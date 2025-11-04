---
on:
  workflow_dispatch:
roles: ["admin", "maintainer", "write"]
engine: 
  id: claude
safe-outputs:
  create-issue:
    title-prefix: "[claude-test] "
    labels: [claude, automation, haiku]
    # min: 1
---

Create an issue in repository ${{ github.repository }} with title "Hello from Claude" and body "World"

Add a haiku about GitHub Actions and AI to the issue body.