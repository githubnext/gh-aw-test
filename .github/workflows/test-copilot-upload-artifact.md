---
on:
  workflow_dispatch:
permissions:
  actions: read
  contents: read
  copilot-requests: write
engine: copilot
pre-agent-steps:
  - name: Create artifact fixture
    run: |
      mkdir -p output
      printf '%s\n' 'GH_AW_UPLOAD_ARTIFACT_E2E' > output/phase-a-artifact.txt
safe-outputs:
  upload-artifact:
    max-uploads: 1
    retention-days: 1
    allowed-paths:
      - output/**
timeout-minutes: 5
---

Upload `output/phase-a-artifact.txt` as a run artifact. Do not modify its contents.
