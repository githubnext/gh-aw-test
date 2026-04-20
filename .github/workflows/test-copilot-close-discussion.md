---
on:
  discussion:
    types: [created]
  reaction: eyes

permissions: read-all

engine: 
  id: copilot

safe-outputs:
  close-discussion:
    target: "triggering"
    # min: 1
---

If the title of the discussion #${{ github.event.discussion.number }} is exactly "Test close discussion from Copilot" then close the discussion with a comment "Closed by Copilot safe output" and resolution reason "RESOLVED".
