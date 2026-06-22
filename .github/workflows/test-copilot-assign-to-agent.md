---
on:
  workflow_dispatch:
  reaction: eyes

permissions: read-all

engine:
  id: copilot

safe-outputs:
  create-issue:
    title-prefix: "[copilot-test] "
    labels: [copilot, automation, haiku]
    # min: 1
    samples:
      - temporary_id: aw_agent_issue
        title: "Test assign to agent from Copilot"
        body: |
          This is a test issue used by test-copilot-assign-to-agent.
  assign-to-agent:
    target: "*"
    allowed: [copilot]
    ignore-if-error: true
    # min: 1
    samples:
      - issue_number: "#aw_agent_issue"
---

Create an issue with title "Test assign to agent from Copilot" and temporary_id `aw_agent_issue`, then assign the Copilot coding agent to that issue by emitting `assign_to_agent` with `issue_number: '#aw_agent_issue'`.
