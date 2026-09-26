---
on:
  workflow_dispatch:
    inputs:
      marker:
        description: Unique JSONL marker to append
        required: true
        type: string
concurrency:
  job-discriminator: ${{ github.run_id }}
permissions:
  contents: read
  actions: read
  issues: read
engine: copilot
tools:
  cache-memory:
    key: phase2-concurrent-jsonl
safe-outputs:
  create-issue:
    max: 1
    samples:
      - title: "Cache memory concurrent merge passed"
        body: "Both concurrent JSONL markers were preserved."
timeout-minutes: 8
---

Append one JSON object containing marker `${{ inputs.marker }}` to
`/tmp/gh-aw/cache-memory/concurrent.jsonl` without changing existing rows.
Then create an issue reporting all distinct markers currently in the file.