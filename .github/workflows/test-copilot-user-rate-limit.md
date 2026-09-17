---
on:
  workflow_dispatch:
permissions:
  contents: read
  issues: read
engine: copilot
user-rate-limit:
  max-runs-per-window: 5
  window: 60
safe-outputs:
  create-issue:
    samples:
      - title: "User rate limit frontmatter passed"
        body: "The canonical max-runs-per-window field compiled."
---

Create one issue confirming the canonical user-rate-limit field compiled.