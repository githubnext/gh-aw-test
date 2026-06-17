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
    # markPullRequestReadyForReview GraphQL mutation is blocked for GITHUB_TOKEN
    # (integration token); requires a user PAT. GH_AW_TEST_PAT is the repo-level PAT.
    github-token: ${{ secrets.GH_AW_TEST_PAT }}
    # min: 1
    samples:
      - reason: "Marked ready for review by Copilot safe output"
---

If the title of the pull request #${{ github.event.pull_request.number }} starts with "Test PR for Copilot Mark Ready" then mark the draft pull request as ready for review using the `mark_pull_request_as_ready_for_review` safe output with the reason "Marked ready for review by Copilot safe output".
