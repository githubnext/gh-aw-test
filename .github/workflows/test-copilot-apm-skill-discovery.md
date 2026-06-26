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
    labels: [copilot, automation]
    # min: 1
---

Use the `apm-skill-discovery` skill from `.agents/skills`.

Invoke that skill and copy its exact token response verbatim as the first line of the issue body.

Create an issue in repository `${{ github.repository }}` with title "Copilot APM skill discovery" and include:
- First line: the exact token returned by `apm-skill-discovery`
- Second line: `Skill used: apm-skill-discovery`
