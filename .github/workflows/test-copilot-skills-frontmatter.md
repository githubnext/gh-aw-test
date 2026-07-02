---
on:
  workflow_dispatch:

permissions:
  issues: read
  pull-requests: read
  actions: read
  contents: read
  discussions: read
  copilot-requests: write

skills:
  - mattpocock/skills/diagnosing-bugs@801dca688564c529fa84f247f64472520d9ebe28

engine:
  id: copilot

safe-outputs:
  create-issue:
    title-prefix: "[copilot-test] "
    labels: [copilot, automation]
    samples:
      - title: "Skills frontmatter is available"
        body: |
          The diagnosing-bugs skill was available during this workflow run.

          Two debugging steps from the skill:
          - Reproduce the bug consistently.
          - Minimize the failing case before changing code.
---

Use the installed `/diagnosing-bugs` skill to answer this question: what are two concrete first steps for debugging a bug report?

Then create an issue in repository ${{ github.repository }} with title "Skills frontmatter is available".

The issue body must:
- say that the diagnosing-bugs skill was available during the workflow run
- include exactly two bullet points summarizing the debugging steps suggested by the skill
