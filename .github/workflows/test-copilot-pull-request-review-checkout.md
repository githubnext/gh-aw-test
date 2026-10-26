---
on:
  pull_request_review:
    types: [submitted]
  bots: [agentic-workflows-dev]
permissions:
  contents: read
  issues: read
  pull-requests: read
  copilot-requests: write
engine:
  id: copilot
safe-outputs:
  add-comment:
    target: triggering
    samples:
      - body: App-authored review checkout passed.
---

Confirm the reviewed pull request branch is checked out, then add the comment `App-authored review checkout passed.` to the pull request.