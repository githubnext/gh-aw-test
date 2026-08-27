---
on:
  workflow_dispatch:

permissions:
  actions: read
  contents: read
  copilot-requests: write

engine:
  id: copilot

steps:
  - name: Generate a deterministic coverage report fixture
    run: |
      mkdir -p "${RUNNER_TEMP}/gh-aw/safeoutputs/upload-code-coverage"
      cat > "${RUNNER_TEMP}/gh-aw/safeoutputs/upload-code-coverage/coverage.xml" <<'COVERAGE_XML'
      <?xml version="1.0" encoding="UTF-8"?>
      <coverage line-rate="1.0" branch-rate="1.0" version="1.0">
        <packages/>
      </coverage>
      COVERAGE_XML
      ls -l "${RUNNER_TEMP}/gh-aw/safeoutputs/upload-code-coverage/coverage.xml"

safe-outputs:
  upload-code-coverage:
    max: 1
    samples:
      - file: coverage.xml
        language: TypeScript
        label: code-coverage/e2e
---

Upload `$RUNNER_TEMP/gh-aw/safeoutputs/upload-code-coverage/coverage.xml` using the `upload_code_coverage` tool with `language` set to `TypeScript` and `label` set to `code-coverage/e2e`.
