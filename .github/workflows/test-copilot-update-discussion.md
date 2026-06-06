---
on:
  discussion:
    types: [created]
  reaction: eyes

if: contains(github.event.discussion.body, 'e2e-marker:test-copilot-update-discussion')

permissions: read-all

engine: 
  id: copilot

safe-outputs:
  update-discussion:
    title:
    body:
    # min: 1
    samples:
      - title: "[UPDATED] Update Discussion Test - Processed by Copilot"
        body: "This discussion was automatically updated by the Copilot agentic workflow."
---

If the title of the discussion #${{ github.event.discussion.number }} is exactly "Test update discussion from Copilot" then:

1. Update the title to "[UPDATED] Update Discussion Test - Processed by Copilot"
2. Append a line to the body saying "This discussion was automatically updated by the Copilot agentic workflow."
