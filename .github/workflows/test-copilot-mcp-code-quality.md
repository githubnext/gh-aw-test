---
on:
  workflow_dispatch:
  reaction: eyes

permissions:
  contents: read
  security-events: read

engine:
  id: copilot

safe-outputs:
  create-issue:
    # min: 1
    samples:
      - title: "Code quality finding from Copilot"
        body: |
          Retrieved a code quality finding using get_code_quality_finding for githubnext/gh-aw-test.

          Summary:
          - Rule: js/missing-await
          - Severity: warning
          - File: e2e.sh
          - Line: 1734

          > AI-generated content by [test-copilot-mcp-code-quality](https://github.com/githubnext/gh-aw-test/actions/runs/123456789) may contain mistakes.

tools:
  github:
    toolsets: [code_security]
---

Use the `get_code_quality_finding` tool to retrieve a code quality finding from repository `githubnext/gh-aw-test`.

Create an issue in repository `${{ github.repository }}` with title "Code quality finding from Copilot" summarizing the finding details (such as rule, severity, and location).

### AI Attribution

Include this footer in your issue description:

```markdown
> AI-generated content by [${{ github.workflow }}](https://github.com/${{ github.repository }}/actions/runs/${{ github.run_id }}) may contain mistakes.
```
