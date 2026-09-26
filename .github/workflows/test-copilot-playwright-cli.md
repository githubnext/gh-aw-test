---
on:
  workflow_dispatch:
permissions:
  contents: read
  issues: read
  copilot-requests: write
engine: copilot
tools:
  playwright:
    mode: cli
safe-outputs:
  create-issue:
    samples:
      - title: "Playwright CLI mode passed"
        body: "A loopback page was opened and inspected with the Playwright CLI."
timeout-minutes: 8
---

Create a small HTML page in `/tmp`, serve it on `127.0.0.1`, and use the
Playwright CLI to open it and read its title. Create one issue reporting the
title and confirming that only the loopback server was visited.