---
on:
  workflow_dispatch:
permissions:
  contents: read
  copilot-requests: write
engine:
  id: copilot
  dynamic-workflows: true
  args: ["--experimental"]
checkout:
  pull-request: false
safe-outputs:
  create-issue:
    max: 1
    title-prefix: "[copilot-test] "
    labels: [copilot, automation]
timeout-minutes: 5
---

Run the registered dynamic workflow `phase-a-dynamic-workflow` exactly once with
arguments `{"marker":"GH_AW_DYNAMIC_WORKFLOW_E2E"}`. Use the dynamic workflow
run tool, not a task agent, shell script, or newly authored workflow. Wait for
the durable run to finish and inspect its result.

Create one issue titled **"Dynamic workflow passed"** only if the run status is
`completed` and its returned JSON contains both `"status":"PASS"` and
`"marker":"GH_AW_DYNAMIC_WORKFLOW_E2E"`. Put the exact returned JSON in the
issue body. If the run fails or cannot be verified, do not create the issue.