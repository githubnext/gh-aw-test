---
on:
  workflow_dispatch:

permissions: read-all

engine: 
  id: copilot

safe-outputs:
  create-issue:
    title-prefix: "[copilot-test] "
    labels: [copilot, automation, haiku]
    # min: 1
    samples:
      - title: "Hello from Copilot"
        body: |
          World

          A haiku for the test:
            code and AI merge
            workflows run through the cloud
            automation flows
---

Create an issue in repository ${{ github.repository }} with title "Hello from Copilot" and body "World"

Add a haiku about GitHub Actions and AI to the issue body.