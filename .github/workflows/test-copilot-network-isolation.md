---
on:
  workflow_dispatch:

permissions: read-all

engine:
  id: copilot

sandbox:
  agent:
    network-isolation: true

safe-outputs:
  create-issue:
    title-prefix: "[copilot-network-isolation-test] "
    labels: [copilot, automation, haiku]
    samples:
      - title: "Hello from Copilot (Network Isolation)"
        body: |
          World

          A haiku for the test:
            containers hold fast
            network paths stay isolated
            workflows still succeed
---

Create an issue in repository ${{ github.repository }} with title "Hello from Copilot (Network Isolation)" and body "World"

Add a haiku about GitHub Actions and AI to the issue body.
