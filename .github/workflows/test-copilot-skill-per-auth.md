---
on:
  workflow_dispatch:
permissions:
  contents: read
  issues: read
  copilot-requests: write
skills:
  - mattpocock/skills/diagnosing-bugs@801dca688564c529fa84f247f64472520d9ebe28
  - skill: mattpocock/skills/domain-modeling@801dca688564c529fa84f247f64472520d9ebe28
    github-token: ${{ secrets.GH_AW_TEST_PAT }}
engine:
  id: copilot
safe-outputs:
  create-issue:
    title-prefix: "[skill-per-auth] "
    samples:
      - title: Per-skill authentication passed
        body: Both authenticated and shared-auth skills were installed.
---

Use the installed skills, then create one issue titled `Per-skill authentication passed` with body `Both authenticated and shared-auth skills were installed.`