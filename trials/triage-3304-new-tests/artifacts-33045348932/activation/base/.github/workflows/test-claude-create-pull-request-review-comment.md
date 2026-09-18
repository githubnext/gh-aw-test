---
on:
  slash_command:
    name: test-claude-create-pull-request-review-comment
  reaction: eyes

permissions:
  issues: read
  pull-requests: read
  actions: read
  contents: read
  discussions: read
  copilot-requests: write

engine: 
  id: claude

safe-outputs:
  create-pull-request-review-comment:
    max: 3
    # min: 1
    samples:
      - path: "README.md"
        line: 2
        body: "This code is magnificent! The structure is clear and the implementation is excellent."
---

Analyze the pull request #${{ github.event.issue.number }} and create one code review comment on the code changes. 

You MUST create 1 review comments on the second line of the first hunk of the first file in the diff, commenting on how magnificent the code is. Really go to town on praising the code.
