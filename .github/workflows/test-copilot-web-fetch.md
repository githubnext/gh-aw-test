---
on:
  workflow_dispatch:
permissions:
  contents: read
  copilot-requests: write
engine:
  id: copilot
  copilot-sdk: true
tools:
  web-fetch: {}
timeout-minutes: 5
---

Fetch `https://example.com/` with the built-in web-fetch tool and report the page title.