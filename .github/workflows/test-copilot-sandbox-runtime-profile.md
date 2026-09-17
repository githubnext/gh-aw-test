---
on:
  workflow_dispatch:
permissions:
  contents: read
  issues: read
engine: copilot
sandbox:
  agent:
    runtime: docker-sudo-iptables
safe-outputs:
  create-issue:
    samples:
      - title: "Explicit sandbox runtime profile passed"
        body: "The agent ran with docker-sudo-iptables."
timeout-minutes: 5
---

Create one issue confirming that this workflow ran using the explicit
`docker-sudo-iptables` sandbox runtime profile.