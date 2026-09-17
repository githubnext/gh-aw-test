---
on:
  workflow_dispatch:
permissions:
  contents: read
  issues: read
  copilot-requests: write
network:
  allowed: [defaults, copilot]
engine: copilot
safe-outputs:
  create-issue:
    samples:
      - title: "Explicit Copilot network domain passed"
        body: "The agent completed with the copilot domain set explicitly enabled."
timeout-minutes: 5
---

Create one issue confirming that inference and safe-output processing completed
with the `copilot` network domain set explicitly opted in.