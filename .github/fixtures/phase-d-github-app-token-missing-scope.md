---
on:
  workflow_dispatch:
permissions:
  contents: read
steps:
  - name: Mint deliberately unscoped App token
    uses: actions/create-github-app-token@v3.3.0
    with:
      app-id: ${{ vars.GH_AW_TEST_APP_ID }}
      private-key: ${{ secrets.GH_AW_TEST_APP_PRIVATE_KEY }}
      owner: githubnext
      repositories: gh-aw-test
engine:
  id: copilot
---

This fixture must be rejected before execution.