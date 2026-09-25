---
on:
  workflow_dispatch:
  cooldown: 5m
permissions:
  contents: read
  actions: read
  issues: read
engine: copilot
safe-outputs:
  create-issue:
    samples:
      - title: "Cooldown agent execution marker"
        body: "The agent job was allowed to execute."
timeout-minutes: 5
---

Create one issue titled "Cooldown agent execution marker" to prove that the
agent job was allowed to execute.