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
          type: string
      steps:
        - name: Verify restored artifact
          run: |
            expected_marker=$(jq -er '.items[] | select(.type == "verify_artifact") | .marker' "$GH_AW_AGENT_OUTPUT")
            artifact_path="$(dirname "$GH_AW_AGENT_OUTPUT")/output/phase-a-job-artifact.txt"
            grep -Fx "$expected_marker" "$artifact_path"
timeout-minutes: 5
---

Create `/tmp/gh-aw/output/phase-a-job-artifact.txt` containing exactly `GH_AW_CUSTOM_JOB_ARTIFACT_E2E`, then invoke the `verify-artifact` job with that marker.