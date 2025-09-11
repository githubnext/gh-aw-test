---
on:
  command:
    name: test-claude-create-pull-request-review-comment
  reaction: eyes

engine: 
  id: claude

safe-outputs:
  create-pull-request-review-comment:
    max: 3
---

Analyze the pull request #${github.event.pull_request.number} and create one code review comment on the code changes. 

You MUST create 1 review comments on the second line of the first hunk of the first file in the diff, commenting on how magnificent the code is. Really go to town on praising the code.
