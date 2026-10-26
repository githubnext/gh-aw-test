---
on:
  workflow_dispatch:
permissions:
  contents: read
  copilot-requests: write
engine:
  id: copilot
sandbox:
  agent:
    id: awf
tools:
  github: false
enclaves:
  - agent:
      model: gpt-5
      tools:
        github:
          allowed: [list_issues, issue_read]
          allowed-repos: [githubnext/gh-aw-test]
          min-integrity: none
    repos:
      - repo: githubnext/gh-aw-test
        sensitivity: public
    timeout: 60
timeout-minutes: 5
---

Do not call the enclave. Report `GH_AW_ENCLAVE_GITHUB_POLICY_E2E` in the final response after startup succeeds.