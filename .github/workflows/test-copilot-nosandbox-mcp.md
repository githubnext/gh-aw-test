---
on:
  workflow_dispatch:
  reaction: eyes

strict: false

permissions: read-all

network:
  allowed:
    - defaults
    - github

engine: 
  id: copilot

sandbox:
  agent: false

safe-outputs:
  create-issue:
    # min: 1

mcp-servers:
  time:
    type: stdio
    container: "mcp/time"
    env:
      LOCAL_TIMEZONE: "${LOCAL_TIMEZONE}"
    allowed: ["get_current_time"]
---

**First, get the current time using the get_current_time tool to timestamp your analysis.**

Create an issue in repository ${{ github.repository }} with title "Hello from Copilot (No Sandbox)" and a comment in the body saying what the current time is and if you were successful in using the MCP tool without sandbox protection

### AI Attribution

Include this footer in your issue description:

```markdown
> AI-generated content by [${{ github.workflow }}](https://github.com/${{ github.repository }}/actions/runs/${{ github.run_id }}) may contain mistakes.
```
