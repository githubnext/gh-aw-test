---
on:
  workflow_dispatch:

engine: 
  id: copilot

safe-outputs:
  create-issue:
    title-prefix: "[copilot-test] "
    labels: [copilot, automation, haiku]
    min: 1
---

Create an issue with title "Hello from Copilot" and body "World"

Add a haiku about GitHub Actions and AI to the issue body.