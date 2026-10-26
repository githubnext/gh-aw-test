---
on:
  workflow_dispatch:
    inputs:
      marker:
        description: Unique marker file stem
        required: true
        type: string
concurrency:
  job-discriminator: ${{ github.run_id }}
permissions:
  actions: read
  contents: read
  issues: read
  copilot-requests: write
engine:
  id: copilot
tools:
  repo-memory:
    branch-name: memory/e2e-repo-memory-concurrent
    description: Concurrent retry E2E
    file-glob: ["*.txt"]
safe-outputs:
  create-issue:
    title-prefix: "[repo-memory-concurrent] "
    samples:
      - title: Write completed
        body: Concurrent repo-memory marker write completed.
timeout-minutes: 8
---

Write `${{ inputs.marker }}` to `/tmp/gh-aw/repo-memory/default/${{ inputs.marker }}.txt`, preserving all existing files. Create one issue titled `Write completed` after the write.