---
on:
  issues:
    types: [opened, reopened]
  reaction: eyes

if: contains(github.event.issue.body, 'e2e-marker:test-copilot-link-sub-issue')

permissions: read-all

engine: 
  id: copilot

safe-outputs:
  link-sub-issue:
    # min: 1
    samples:
      - parent_issue_number: 100
        sub_issue_number: 101
---

If the title of the issue #${{ github.event.issue.number }} starts with "[link-sub-issue request]" then:

1. Read the body of issue #${{ github.event.issue.number }}.
2. The body contains two issue numbers in the form `parent=<N>` and `sub=<M>`. Extract those numbers.
3. Link the sub issue as a sub-issue of the parent issue using the `link_sub_issue` safe output (parent_issue_number=<N>, sub_issue_number=<M>).
