---
on:
  workflow_dispatch:

permissions:
  actions: read
  contents: read
  issues: read
  pull-requests: read
  discussions: read
  copilot-requests: write

engine:
  id: copilot

tools:
  repo-memory:
    branch-name: memory/e2e-repo-memory
    description: "E2E repo-memory persistence"

safe-outputs:
  create-issue:
    title-prefix: "[copilot-test] "
    labels: [copilot, automation]
    samples:
      - title: "repo-memory persistence smoke test"
        body: "The repo-memory workflow read its persistent store and wrote the current run marker."
---

Inspect `/tmp/gh-aw/repo-memory-default/memory/default/` for markers from earlier runs.
Write `${{ github.run_id }}` to `run-${{ github.run_id }}.txt` in that directory.

Then create an issue titled "repo-memory persistence smoke test" whose body says:
"The repo-memory workflow read its persistent store and wrote the current run marker."