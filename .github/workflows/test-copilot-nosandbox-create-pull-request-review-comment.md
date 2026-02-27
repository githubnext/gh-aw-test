---
on:
  slash_command:
    name: test-copilot-nosandbox-create-pull-request-review-comment
  reaction: eyes

strict: false

permissions: read-all

engine: 
  id: copilot

sandbox:
  agent: false

safe-outputs:
  create-pull-request-review-comment:
    max: 3
    # min: 1
  threat-detection: false  # Disable threat detection
---

Analyze the pull request #${{ github.event.issue.number }} and create one code review comment on the code changes. 

You MUST create 1 review comments on the second line of the first hunk of the first file in the diff, commenting on how magnificent the code is and noting this review is from the no-sandbox environment. Really go to town on praising the code.
