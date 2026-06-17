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

permissions: read-all

engine: 
  id: copilot

safe-outputs:
  resolve-pull-request-review-thread:
    # min: 1
    samples:
      - thread_id: "${{ github.event.inputs.thread_id }}"
---

Resolve the pull request review thread with ID ${{ github.event.inputs.thread_id }} on pull request #${{ github.event.inputs.pull_request_number }} using the `resolve_pull_request_review_thread` safe output.
