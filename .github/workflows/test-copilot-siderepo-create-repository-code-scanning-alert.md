---
on:
  workflow_dispatch:
  reaction: eyes

permissions: read-all

engine: 
  id: copilot

tools:
  github:
    # The GitHub tools must be authorized to read across-repo 
    github-token: ${{ secrets.TEMP_USER_PAT }}

safe-outputs:
  github-token: ${{ secrets.TEMP_USER_PAT }}
  create-code-scanning-alert:
    max: 10
    # target-repo: 'githubnext/gh-aw-side-repo'
    # allowed-repos: ['githubnext/gh-aw-side-repo']
    # min: 1
    samples:
      - file: "e2e.sh"
        line: 500
        severity: "warning"
        message: "Copilot wants security review. Security is fundamental to software quality. Cross-repository security reviews help maintain consistent security standards across our organization, ensuring all codebases receive proper security scrutiny."
---

Create a Code Scanning Alert in repository githubnext/gh-aw-side-repo with the title "Copilot wants security review."

Write a few sentences about the importance of security in the alert message body.
