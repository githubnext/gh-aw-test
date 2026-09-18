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

safe-outputs:
  missing-data:
    samples:
      - reason: "The E2E fixture intentionally omits required data."
        data_type: "e2e-fixture"
        context: "Testing the missing-data system safe output."
---

Emit a `missing_data` safe output with reason "The E2E fixture intentionally omits required data.", data type "e2e-fixture", and context "Testing the missing-data system safe output.".