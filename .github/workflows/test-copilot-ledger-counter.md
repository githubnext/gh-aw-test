---
on:
  workflow_dispatch:
permissions:
  contents: read
  issues: read
  copilot-requests: write
engine:
  id: copilot
tools:
  ledger:
    phase-c-visits:
      type: counter
safe-outputs:
  create-issue:
    title-prefix: "[ledger-counter] "
    samples:
      - title: Counter operations passed
        body: Counter `phase-c` was incremented twice.
---

Use `ledger_append` twice to increment counter name `phase-c` by 1 in ledger `phase-c-visits`. Query the ledger, then create one issue titled `Counter operations passed` reporting that both operations completed.