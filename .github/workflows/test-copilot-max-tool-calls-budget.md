---
on:
  workflow_dispatch:
permissions:
  contents: read
  copilot-requests: write
engine:
  id: copilot
  copilot-sdk: true
max-tool-calls: 1
tools:
  bash: ["pwd", "ls"]
timeout-minutes: 5
---

First call the bash tool to run `pwd`. Then make a second bash tool call to run `ls`. In your final response, report the result of the enforced tool-call budget.