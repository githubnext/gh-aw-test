---
on:
  repository_dispatch:
    types: [gh-aw-bot-allowlist-e2e]
  bots: [github-actions]
permissions:
  contents: read
  copilot-requests: write
timeout-minutes: 5
---

Confirm that this repository dispatch from the allowlisted GitHub Actions bot was accepted. Include `GH_AW_REPOSITORY_DISPATCH_BOT_E2E` in the final response.