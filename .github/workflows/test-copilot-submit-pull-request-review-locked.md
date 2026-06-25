---
on:
  workflow_dispatch:
    inputs:
      pull_request_number:
        description: 'Pull request number (must be locked)'
        required: true
        type: number

permissions: read-all

engine: 
  id: copilot

safe-outputs:
  submit-pull-request-review:
    max: 1
    allowed-events: [COMMENT]
    target: "*"
    # min: 1 intentionally omitted — the locked PR prevents review submission (soft skip)
    samples:
      - pull_request_number: "${{ github.event.inputs.pull_request_number }}"
        body: "Reviewed by Copilot submit-pull-request-review-locked safe output"
        event: "COMMENT"
---

Analyze the pull request #${{ github.event.inputs.pull_request_number }} and submit a pull request review with the body "Reviewed by Copilot submit-pull-request-review-locked safe output" and event "COMMENT".

The pull request may be locked. If the review submission is blocked because the pull request is locked, that is expected — the workflow should still complete successfully.
