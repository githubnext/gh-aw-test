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
  - name: Test gh in steps
    env:
      GH_TOKEN: ${{ github.token }}
    run: |
      mkdir -p /tmp/gh-aw

      # Count open issues with labels (up to 500)
      gh issue list --state open --limit 500 --json number,labels > /tmp/gh-aw/issues.json
      ISSUE_COUNT=$(python3 -c "import json; print(len(json.load(open('/tmp/gh-aw/issues.json'))))")
      echo "Found $ISSUE_COUNT open issues"
      echo "$ISSUE_COUNT" > /tmp/gh-aw/issue_count.txt

safe-outputs:
  create-issue:
    title-prefix: "[copilot-test-gh-steps] "
    labels: [copilot, automation]
    samples:
      - title: "Issue count report"
        body: "Found 42 open issues in the repository."
---

Read the file /tmp/gh-aw/issue_count.txt which contains the number of open issues counted by a previous step.

Create an issue with title "Test ${{ github.run_id }}: The number of issues is N" where N is the count read from the file.

The body should say "This issue was created to verify that gh steps work correctly."
