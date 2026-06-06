---
on:
  issues:
    types: [opened, reopened]
  reaction: eyes

if: contains(github.event.issue.body, 'e2e-marker:test-copilot-hide-comment')

permissions:
  contents: read
  issues: read

engine: 
  id: copilot

safe-outputs:
  add-comment:
    max: 1
    samples:
      - body: "Hidden by Copilot hide-comment safe output"
  hide-comment:
    max: 1
    # min: 1
    samples:
      - comment_id: "IC_kwDOABCDEF123456"
        reason: "OUTDATED"
---

If the title of the issue #${{ github.event.issue.number }} is exactly "Test hide comment from Copilot" then:

1. List the issue comments on issue #${{ github.event.issue.number }} (the issue body contains the GraphQL node ID of a comment to hide on a line starting with `hide-comment-node-id=`).
2. Extract the comment node ID from the body of issue #${{ github.event.issue.number }}.
3. Use the `hide_comment` safe output to hide that comment with reason "outdated".
4. Use the `add_comment` safe output to post the comment "Hidden by Copilot hide-comment safe output" on the issue so the test can validate the workflow ran successfully.
