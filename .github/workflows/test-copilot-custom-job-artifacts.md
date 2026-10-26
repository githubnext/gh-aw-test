---
on:
  workflow_dispatch:
permissions:
  contents: read
  copilot-requests: write
safe-outputs:
  jobs:
    verify-artifact:
      runs-on: ubuntu-latest
      artifacts:
        - /tmp/gh-aw/output/
      inputs:
        marker:
          description: Marker expected in the restored artifact
          required: true
      steps:
        - name: Verify restored artifact
          env:
            EXPECTED_MARKER: ${{ inputs.marker }}
          run: grep -Fx "$EXPECTED_MARKER" /tmp/gh-aw/output/phase-a-job-artifact.txt
timeout-minutes: 5
---

Create `/tmp/gh-aw/output/phase-a-job-artifact.txt` containing exactly `GH_AW_CUSTOM_JOB_ARTIFACT_E2E`, then invoke the `verify-artifact` job with that marker.