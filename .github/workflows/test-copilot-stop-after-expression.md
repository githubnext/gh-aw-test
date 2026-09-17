---
on:
  workflow_dispatch:
    inputs:
      expiry:
        description: Runtime stop-after timestamp
        required: true
        type: string
  stop-after: ${{ inputs.expiry }}
concurrency:
  job-discriminator: ${{ github.run_id }}
permissions:
  contents: read
  issues: read
engine: copilot
safe-outputs:
  create-issue:
    samples:
      - title: "Stop-after future execution marker"
        body: "The future runtime stop-after expression allowed execution."
---

Create one issue proving that the runtime stop-after expression allowed the
agent job to execute.