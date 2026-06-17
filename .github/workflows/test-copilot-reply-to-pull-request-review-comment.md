---
on:
  workflow_dispatch:
    inputs:
      pull_request_number:
        description: "Pull request number containing the review comment"
        required: true
        type: string
      comment_id:
        description: "ID of the review comment to reply to"
        required: true
        type: string
  reaction: eyes

permissions: read-all

engine: 
  id: copilot

safe-outputs:
  reply-to-pull-request-review-comment:
    target: "*"  # workflow_dispatch has no PR context; pull_request_number comes from inputs
    # min: 1
    samples:
      - comment_id: "${{ github.event.inputs.comment_id }}"
        pull_request_number: "${{ github.event.inputs.pull_request_number }}"
        body: "Reply from Copilot reply-to-pull-request-review-comment safe output"
---

Reply to the pull request review comment with ID ${{ github.event.inputs.comment_id }} on pull request #${{ github.event.inputs.pull_request_number }} using the `reply_to_pull_request_review_comment` safe output with the body "Reply from Copilot reply-to-pull-request-review-comment safe output".
