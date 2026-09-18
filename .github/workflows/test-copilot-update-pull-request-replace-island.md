---
on:
  pull_request:
    types: [opened, reopened]
  reaction: eyes
if: contains(github.event.pull_request.body, 'e2e-marker:test-copilot-update-pull-request-replace-island')
permissions:
  issues: read
  pull-requests: read
  contents: read
engine: copilot
safe-outputs:
  update-pull-request:
    body: true
    operation: replace-island
    footer: false
    samples:
      - body: "The marker-delimited island was replaced by the Copilot E2E workflow."
---

Replace only the marker-delimited island in the triggering pull request body with:
"The marker-delimited island was replaced by the Copilot E2E workflow."