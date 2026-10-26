---
on:
  workflow_dispatch:
permissions:
  contents: read
  copilot-requests: write
checkout:
  - multi: true
    repository: ${{ vars.GH_AW_TEST_CHECKOUT_REPOS }}
    path: targets
    allowed-repos: ${{ vars.GH_AW_TEST_ALLOWED_CHECKOUT_REPOS }}
    max-repos: 3
    github-token: ${{ secrets.GH_AW_TEST_PAT }}
timeout-minutes: 5
---

List the repositories checked out under `targets` and report their directory names.