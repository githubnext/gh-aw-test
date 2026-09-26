---
on:
  workflow_dispatch:
permissions:
  contents: read
  issues: read
  copilot-requests: write
engine:
  id: copilot
  env:
    E2E_EXCLUDED_VALUE: "visible-on-runner-not-in-agent"
excluded-env: [E2E_EXCLUDED_VALUE]
safe-outputs:
  create-issue:
    samples:
      - title: "Sandbox excluded environment passed"
        body: "E2E_EXCLUDED_VALUE was absent inside the agent sandbox."
timeout-minutes: 5
---

Check whether `E2E_EXCLUDED_VALUE` is present in your environment. Create one
issue reporting success only if the variable is absent from the agent sandbox.