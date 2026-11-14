---
on:
  workflow_dispatch:
    inputs:
      marker:
        description: Beta marker
        required: true
        type: string
permissions:
  contents: read
  issues: read
  copilot-requests: write
engine:
  id: copilot
tools:
  repo-memory:
    branch-name: memory/e2e-repo-memory-shared
    description: Shared branch beta view
    file-glob: ["beta/*.txt"]
safe-outputs:
  create-issue:
    title-prefix: "[repo-memory-beta] "
    samples:
      - title: Beta write completed
        body: Beta sibling marker written.
---

Create directory `/tmp/gh-aw/repo-memory/default/beta` and write `${{ inputs.marker }}` to `/tmp/gh-aw/repo-memory/default/beta/${{ inputs.marker }}.txt`. Create one issue titled `Beta write completed`.