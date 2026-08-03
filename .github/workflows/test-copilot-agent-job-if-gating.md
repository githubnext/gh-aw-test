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
    steps:
      - name: Set gate flag
        id: gate
        run: echo "should_run=true" >> "$GITHUB_OUTPUT"
  agent:
    needs: [setup]
    if: needs.setup.outputs.should_run == 'true'

safe-outputs:
  create-issue:
    title-prefix: "[copilot-test] "
    labels: [copilot, automation]
    samples:
      - title: "agent-job-if-gating smoke test"
        body: "The agent job ran after the setup job set should_run=true, confirming jobs.agent.if gating works."
---

Create an issue in repository ${{ github.repository }} titled "agent-job-if-gating smoke test".

The body should say: "The agent job ran after the setup job set should_run=true, confirming jobs.agent.if gating works."
