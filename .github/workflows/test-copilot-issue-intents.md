---
on:
  workflow_dispatch:

permissions: read-all

engine: 
  id: copilot

features:
  issue-intents: true

safe-outputs:
  create-issue:
    title-prefix: "[copilot-test] "
    labels: [copilot, automation, haiku]
    # min: 1
    samples:
      - title: "Hello from Copilot (issue-intents)"
        body: |
          World

          A haiku for the test:
            intents wrap the call
            rationale and confidence
            server decides path
---

Create an issue in repository ${{ github.repository }} with title "Hello from Copilot (issue-intents)" and body "World"

Add a haiku about issue intents and AI to the issue body.
