---
on:
  workflow_dispatch:
permissions:
  contents: read
  issues: read
  copilot-requests: write
engine:
  id: copilot
  copilot-sdk: true
safe-outputs:
  create-issue:
    title-prefix: "[copilot-sdk-mode] "
    samples:
      - title: SDK mode passed
        body: Stable Copilot SDK mode completed successfully.
---

Create one issue titled `SDK mode passed` with body `Stable Copilot SDK mode completed successfully.`