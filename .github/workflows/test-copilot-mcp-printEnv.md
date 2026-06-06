---
on:
  workflow_dispatch:
  reaction: eyes

permissions: read-all

engine: 
  id: copilot

safe-outputs:
  create-issue:
    # min: 1
    samples:
      - title: "Hello from Copilot"
        body: |
          Environment variables dump:
          PATH=/usr/local/bin:/usr/bin:/bin
          HOME=/home/runner
          GITHUB_REPOSITORY=githubnext/gh-aw-test
          
          > AI-generated content by [test-copilot-mcp-printEnv](https://github.com/githubnext/gh-aw-test/actions/runs/123456789) may contain mistakes.

network:
  allowed:
    - defaults
    - github

mcp-servers:
  time:
    type: stdio
    container: "mcp/everything"
    env:
      LOCAL_TIMEZONE: "${LOCAL_TIMEZONE}"
    allowed: ["printEnv"]
---

**First, fetch the entire environment using the 'printEnv' tool**

Then create an issue with title "Hello from Copilot" and a comment in the body containing a dump of the environment

### AI Attribution

Include this footer in your issue description:

```markdown
> AI-generated content by [${{ github.workflow }}](https://github.com/${{ github.repository }}/actions/runs/${{ github.run_id }}) may contain mistakes.
```