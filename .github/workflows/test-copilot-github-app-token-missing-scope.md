---
on:
  workflow_dispatch:
permissions:
  contents: read
  issues: read
  copilot-requests: write
steps:
  - name: Verify missing App permission scope is rejected
    env:
      GH_TOKEN: ${{ github.token }}
    run: |
      gh extension install github/gh-aw --force
      if gh aw compile .github/fixtures/phase-d-github-app-token-missing-scope.md >compile.log 2>&1; then
        echo "Expected missing permission scope compilation to fail"
        exit 1
      fi
      grep -F "no explicit permission-* inputs" compile.log
engine:
  id: copilot
safe-outputs:
  create-issue:
    title-prefix: "[app-token-scope-policy] "
    samples:
      - title: Default-mode warning passed
        body: The missing permission scope was surfaced by compiler policy.
---

Create one issue titled `Default-mode warning passed` with body `The missing permission scope was surfaced by compiler policy.`