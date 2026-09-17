---
on:
  workflow_dispatch:
permissions:
  contents: read
  issues: read
engine: copilot
safe-outputs:
  create-issue:
    samples:
      - title: "Evals frontmatter smoke test"
        body: "A fixed issue was created for binary evaluation."
evals:
  - id: issue_created
    question: Did the agent create an issue with the requested fixed title?
---

Create one issue titled "Evals frontmatter smoke test" with a short body.