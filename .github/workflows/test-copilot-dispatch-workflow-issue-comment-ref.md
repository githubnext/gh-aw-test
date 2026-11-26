---
on:
  slash_command:
    name: test-copilot-dispatch-workflow-issue-comment-ref
  reaction: eyes
permissions:
  actions: read
  contents: read
  issues: read
  pull-requests: read
  copilot-requests: write
engine:
  id: copilot
safe-outputs:
  dispatch-workflow:
    workflows: [test-copilot-dispatch-worker]
    allowed-refs: ["refs/heads/*"]
    max: 1
    samples:
      - workflow_name: test-copilot-dispatch-worker
        inputs:
          sentinel: issue-comment-${{ github.event.issue.number }}
---

Dispatch `test-copilot-dispatch-worker` without a ref override. Set its `sentinel` input to `issue-comment-${{ github.event.issue.number }}`.