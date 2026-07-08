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
  report-incomplete:
    samples:
      - reason: "set_issue_field rejected builtin field 'title'"
        details: "The field 'title' is a builtin field. Use update_issue to set builtin fields."
---

Call `set_issue_field` with `issue_number: 1`, `field_name: "title"`, and `value: "New title"`. The handler will reject this because `title` is a builtin field. Report the operation as incomplete using `report_incomplete`, with the reason being that `set_issue_field` rejected the builtin field name and directed you to use `update_issue` instead.
