---
on:
  workflow_dispatch:
permissions:
  contents: read
  copilot-requests: write
steps:
  - name: Start custom-CA MCP fixture
    run: |
      openssl req -x509 -newkey rsa:2048 -nodes -days 1 \
        -keyout "$RUNNER_TEMP/phase-a-mcp-key.pem" \
        -out "$RUNNER_TEMP/phase-a-mcp-ca.pem" \
        -subj '/CN=localhost' \
        -addext 'subjectAltName=DNS:localhost,DNS:host.docker.internal'
      node .github/fixtures/phase-a-https-mcp-server.mjs \
        "$RUNNER_TEMP/phase-a-mcp-key.pem" \
        "$RUNNER_TEMP/phase-a-mcp-ca.pem" &
      for attempt in {1..20}; do
        curl --silent --fail --cacert "$RUNNER_TEMP/phase-a-mcp-ca.pem" \
          https://localhost:3443/health && exit 0
        sleep 1
      done
      exit 1
mcp-servers:
  custom-ca:
    type: http
    url: https://host.docker.internal:3443/mcp
    ca-cert-file: ${{ runner.temp }}/phase-a-mcp-ca.pem
    allowed: [phase_a_marker]
timeout-minutes: 5
---

Call the `phase_a_marker` tool from the custom-CA MCP server and report its marker.