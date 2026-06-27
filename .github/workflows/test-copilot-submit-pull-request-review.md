---
on:
  slash_command:
    name: test-copilot-submit-pull-request-review
  reaction: eyes

permissions:
  issues: read
  pull-requests: read
  actions: read
  contents: read
  discussions: read
  copilot-requests: write

engine: 
  id: copilot

safe-outputs:
  create-pull-request-review-comment:
    max: 3
  submit-pull-request-review:
    max: 1
    allowed-events: [COMMENT]
    # min: 1
    samples:
      - body: "Reviewed by Copilot submit-pull-request-review safe output"
        event: "COMMENT"
---

Analyze the pull request #${{ github.event.issue.number }} and submit a pull request review.

You MUST:
1. Create 1 review comment on the second line of the first hunk of the first file in the diff, commenting on how magnificent the code is.
2. Submit a pull request review with the body "Reviewed by Copilot submit-pull-request-review safe output" and event "COMMENT" so the inline comment is published as part of a consolidated review.
