---
on:
  workflow_dispatch:
engine: copilot
permissions:
  contents: read
  issues: read
safe-outputs:
  body-footer: "Global footer from {workflow_name}: {run_url}"
  create-issue:
    title-prefix: "[copilot-test] "
    labels: [copilot, automation]
    body-footer: "Handler-specific create-issue footer."
    samples:
      - title: "body-footer composition smoke test"
        body: "Base body for the body-footer composition test."
---

Create an issue titled "body-footer composition smoke test" with body:
"Base body for the body-footer composition test."