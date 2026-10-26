---
on:
  workflow_dispatch:
    inputs:
      marker:
        description: Alpha marker
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
    description: Shared branch alpha view
    file-glob: ["alpha/*.txt"]
safe-outputs:
  create-issue:
    title-prefix: "[repo-memory-alpha] "
    samples:
      - title: Alpha write completed
        body: Alpha sibling marker written.
---

Create directory `/tmp/gh-aw/repo-memory/default/alpha` and write `${{ inputs.marker }}` to `/tmp/gh-aw/repo-memory/default/alpha/${{ inputs.marker }}.txt`. Create one issue titled `Alpha write completed`.