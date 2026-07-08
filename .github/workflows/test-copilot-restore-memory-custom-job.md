---
on:
  workflow_dispatch:

permissions:
  issues: read
  pull-requests: read
  actions: read
  contents: read
  discussions: read
  copilot-requests: write

engine:
  id: copilot

jobs:
  setup:
    restore-memory:
      cache-memory: true
    steps:
      - name: Verify cache-memory restore step was injected
        run: echo "cache-memory restore step injection verified"
  agent:
    needs: [setup]

safe-outputs:
  create-issue:
    title-prefix: "[copilot-test] "
    labels: [copilot, automation]
    samples:
      - title: "restore-memory custom job smoke test"
        body: "The restore-memory step was injected into the custom setup job and the agent job ran after it."
---

Create an issue in repository ${{ github.repository }} titled "restore-memory custom job smoke test".

The body should say: "The restore-memory step was injected into the custom setup job and the agent job ran after it."
