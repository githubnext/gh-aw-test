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
  copilot-sdk: true
  model: gpt-5.3-codex

safe-outputs:
  create-issue:
    title-prefix: "[copilot-test] "
    labels: [copilot, automation]
    # min: 1
    samples:
      - title: "Inline sub-agent smoke test"
        body: |
          Parent greeting: hello

          Mini sub-agent response: hello from gpt-5-mini

          Haiku sub-agent response: hello from claude-haiku-4.5
---

Call the inline sub-agents `mini-greeter` and `haiku-greeter` exactly once each with the greeting `hello`.

Create one issue in repository ${{ github.repository }} titled "Inline sub-agent smoke test".

The issue body must be exactly:
Parent greeting: hello

Mini sub-agent response: <the mini sub-agent response>

Haiku sub-agent response: <the haiku sub-agent response>

Keep the output short and do not use any other agent.

## agent: `mini-greeter`
---
description: Returns a fixed greeting for Copilot SDK inline sub-agent smoke testing
model: gpt-5-mini
---
When given the greeting `hello`, reply with exactly:

`hello from gpt-5-mini`

No extra words, punctuation, or formatting.

## agent: `haiku-greeter`
---
description: Returns a fixed greeting for Copilot SDK inline sub-agent smoke testing
model: claude-haiku-4.5
---
When given the greeting `hello`, reply with exactly:

`hello from claude-haiku-4.5`

No extra words, punctuation, or formatting.
