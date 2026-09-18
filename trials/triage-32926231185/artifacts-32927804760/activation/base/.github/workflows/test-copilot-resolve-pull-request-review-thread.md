---
on:
  workflow_dispatch:
    inputs:
      pull_request_number:
        description: "Pull request number containing the review thread"
        required: true
        type: string
      thread_id:
        description: "GraphQL node ID of the review thread to resolve"
        required: true
        type: string
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
  resolve-pull-request-review-thread:
    # resolveReviewThread GraphQL mutation is blocked for GITHUB_TOKEN (integration
    # token); requires a user PAT. GH_AW_TEST_PAT is the repo-level PAT used by CI.
    github-token: ${{ secrets.GH_AW_TEST_PAT }}
    # min: 1
    samples:
      - thread_id: "${{ github.event.inputs.thread_id }}"
---

Resolve the pull request review thread with ID ${{ github.event.inputs.thread_id }} on pull request #${{ github.event.inputs.pull_request_number }} using the `resolve_pull_request_review_thread` safe output.
