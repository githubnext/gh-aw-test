---
on:
  workflow_dispatch:
permissions:
  contents: read
engine:
  id: claude
tools:
  web-search: {}
timeout-minutes: 5
---

Use the built-in web-search tool to find the official GitHub Agentic Workflows repository. Report its `owner/repository` name.