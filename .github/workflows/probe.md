---
on:
  workflow_dispatch:
permissions:
  contents: read
  issues: read
engine:
  id: copilot
tools:
  comment-memory:
    target: "*"
safe-outputs:
  add-comment:
    max: 1
    target: "*"
---

Do nothing.
