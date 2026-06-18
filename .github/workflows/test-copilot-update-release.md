---
on:
  workflow_dispatch:
    inputs:
      release_tag:
        description: "Tag of the existing release to update"
        required: true
        type: string
  reaction: eyes

permissions: read-all

engine: 
  id: copilot

safe-outputs:
  update-release:
    footer: false
    # min: 1
    samples:
      - tag: "${{ github.event.inputs.release_tag }}"
        operation: "append"
        body: "Updated by Copilot update-release safe output"
---

Append the text "Updated by Copilot update-release safe output" to the body of the release tagged ${{ github.event.inputs.release_tag }} using the `update_release` safe output with operation "append".
