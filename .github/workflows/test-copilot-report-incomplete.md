---
on:
  workflow_dispatch:

permissions: read-all

engine: 
  id: copilot

safe-outputs:
  report-incomplete:
    # min: 1
    samples:
      - reason: "Demonstrating the report-incomplete safe output from Copilot"
        details: "This run intentionally reports that it could not complete."
---

Report that the task is incomplete using the `report_incomplete` safe output with the reason "Demonstrating the report-incomplete safe output from Copilot" and details "This run intentionally reports that it could not complete.".
