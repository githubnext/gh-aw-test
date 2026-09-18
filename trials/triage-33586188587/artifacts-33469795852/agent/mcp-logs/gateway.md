<details>
<summary>MCP Gateway</summary>

- ✓ **startup** MCPG Gateway version: v0.4.13
- ✓ **startup** Starting MCPG with config: stdin, listen: 0.0.0.0:8080, log-dir: /tmp/gh-aw/mcp-logs/
- ✓ **startup** WASM compilation cache directory: /tmp/gh-aw/wazero-cache
- ✓ **startup** Environment validation passed
- ✓ **startup** Loaded 2 MCP server(s): [github safeoutputs]
- ✓ **startup** Guards sink server ID logging enrichment disabled (no sink server IDs configured)
- ✓ **startup** OpenTelemetry tracing disabled (no OTLP endpoint configured)
- ✓ **backend**
  ```
  Successfully connected to MCP backend server, command=docker
  ```
- 🔍 rpc **safeoutputs**→`tools/list`
- 🔍 rpc **safeoutputs**←`resp` `{"jsonrpc":"2.0","id":1,"result":{"ttlMs":0,"cacheScope":"","tools":[{"description":"WRITE-ONCE: do NOT call this tool with empty or placeholder arguments to probe or discover its schema — the required `body` field is listed in this schema; if you are not ready to post a real comment, call `noop` instead. Adds a comment to an existing GitHub issue, pull request, or discussion. Use this to provide feedback, answer questions, or add information to an existing conversation. For creating new items, use create...`
- ✓ **backend**
  ```
  Successfully connected to MCP backend server, command=docker
  ```
- 🔍 rpc **github**→`tools/list`
- 🔍 rpc **github**←`resp` `{"jsonrpc":"2.0","id":1,"result":{"ttlMs":0,"cacheScope":"","tools":[{"annotations":{"idempotentHint":false,"readOnlyHint":true,"title":"Get details of GitHub Actions resources (workflows, workflow runs, jobs, and artifacts)"},"description":"Get details about specific GitHub Actions resources.\nUse this tool to get details about individual workflows, workflow runs, jobs, and artifacts by their unique IDs.\n","inputSchema":{"properties":{"method":{"description":"The method to execute","enum":["get_workflow",...`
- 🔍 rpc **github**→`prompts/list`
- 🔍 rpc **github**←`resp` `{"jsonrpc":"2.0","id":1,"result":{"ttlMs":0,"cacheScope":"","prompts":[{"arguments":[{"name":"repo","description":"The repository to assign tasks in (owner/repo).","required":true}],"description":"Assign GitHub Coding Agent to multiple tasks in a GitHub repository.","name":"AssignCodingAgent","icons":[{"src":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAABmJLR0QA/wD/AP+gvaeTAAAC2UlEQVRIicWVMUyTaRjHf/+vVUpOJOdilOYoUvVreq2CDmLOwdlAS5xMbrrhBifjYG7QjYuJw108nZx1huLgYlw0QshxChUK2koxHHcuCmg...`
- ✓ **startup** Starting MCPG in ROUTED mode on 0.0.0.0:8080
- ✓ **startup** Routes: /mcp/<server> where <server> is one of: [github safeoutputs]
- ✓ **startup** TLS not configured — listening on http://0.0.0.0:8080 (set --tls-cert/--tls-key to enable)
- ✓ **shutdown** Shutting down gateway...

</details>
