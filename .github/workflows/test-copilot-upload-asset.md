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

engine:
  id: copilot

tools:
  bash: true

steps:
  - name: Generate a deterministic PNG asset
    run: |
      mkdir -p /tmp/gh-aw
      # Smallest valid 1x1 transparent PNG, decoded from a fixed base64 blob so
      # the file exists on disk before the samples replay calls upload_asset.
      printf '%s' \
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAC0lEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==' \
        | base64 -d > /tmp/gh-aw/e2e-asset.png
      ls -l /tmp/gh-aw/e2e-asset.png

safe-outputs:
  upload-asset:
    branch: assets/test-copilot-upload-asset
    allowed-exts: [.png]
    max: 1
    samples:
      - path: /tmp/gh-aw/e2e-asset.png
---

Upload the image file at /tmp/gh-aw/e2e-asset.png as an asset using the upload_asset tool so it is committed to the assets branch with a publicly addressable URL.
