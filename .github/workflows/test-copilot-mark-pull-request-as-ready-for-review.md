---
on:
  pull_request:
    types: [opened, reopened]
  reaction: eyes

if: contains(github.event.pull_request.body, 'e2e-marker:test-copilot-mark-pull-request-as-ready-for-review')

permissions: read-all

engine: 
  id: copilot

safe-outputs:
  mark-pull-request-as-ready-for-review:
    target: "triggering"
    # min: 1
    samples:
      - reason: "Marked ready for review by Copilot safe output"
---

If the title of the pull request #${{ github.event.pull_request.number }} starts with "Test PR for Copilot Mark Ready" then mark the draft pull request as ready for review using the `mark_pull_request_as_ready_for_review` safe output with the reason "Marked ready for review by Copilot safe output".
