---
on:
  workflow_dispatch:

permissions: read-all

engine:
  id: copilot

safe-outputs:
  create-issue:
    title-prefix: "[copilot-test] "
    labels: [copilot, automation, haiku]
    max: 1
    samples:
      - temporary_id: "aw_field_issue"
        title: "Set issue field coverage test"
        body: "Created to validate set_issue_field temporary_id resolution in same batch."
  set-issue-field:
    allowed-fields: ["Priority"]
    max: 1
    samples:
      - issue_number: "#aw_field_issue"
        field_name: "Priority"
        value: "Medium"
---

Return exactly two safe outputs in one batch:
1) `create_issue` with temporary_id `aw_field_issue`, title "Set issue field coverage test", and body "Created to validate set_issue_field temporary_id resolution in same batch."
2) `set_issue_field` targeting `issue_number: '#aw_field_issue'`, `field_name: 'Priority'`, and `value: 'Medium'`.
