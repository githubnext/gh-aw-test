<details>
<summary>MCP Gateway</summary>

- ✓ **startup** MCPG Gateway version: v0.4.14
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
- 🔍 rpc **safeoutputs**←`resp` `{"jsonrpc":"2.0","id":1,"result":{"ttlMs":0,"cacheScope":"","tools":[{"description":"Experimental. Upload a code coverage report (e.g. a Cobertura XML file) to GitHub's code coverage API via actions/upload-code-coverage. Before calling this tool, write or copy the coverage report file into the upload-code-coverage staging directory at /tmp/gh-aw/safeoutputs/upload-code-coverage/ (or provide an absolute path / workspace-relative path, which will be auto-copied into staging). Shell variable syntax (for exampl...`
- ✓ **backend**
  ```
  Successfully connected to MCP backend server, command=docker
  ```
- 🔍 rpc **github**→`tools/list`
- 🔍 rpc **github**←`resp` `{"jsonrpc":"2.0","id":1,"result":{"ttlMs":0,"cacheScope":"","tools":[{"annotations":{"idempotentHint":false,"readOnlyHint":true,"title":"Get commit details"},"description":"Get details for a commit from a GitHub repository","inputSchema":{"properties":{"detail":{"default":"stats","description":"Level of detail to include for changed files. \"none\" omits stats and files entirely. \"stats\" (default) includes per-file metadata: filename, status, and lines-of-code counts (additions, deletions, changes), with ...`
- 🔍 rpc **github**→`prompts/list`
- 🔍 rpc **github**←`resp` `{"jsonrpc":"2.0","id":1,"result":{"ttlMs":0,"cacheScope":"","prompts":[{"arguments":[{"name":"repo","description":"The repository to assign tasks in (owner/repo).","required":true}],"description":"Assign GitHub Coding Agent to multiple tasks in a GitHub repository.","name":"AssignCodingAgent","icons":[{"src":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAABmJLR0QA/wD/AP+gvaeTAAAC2UlEQVRIicWVMUyTaRjHf/+vVUpOJOdilOYoUvVreq2CDmLOwdlAS5xMbrrhBifjYG7QjYuJw108nZx1huLgYlw0QshxChUK2koxHHcuCmg...`
- ✓ **startup** Starting MCPG in ROUTED mode on 0.0.0.0:8080
- ✓ **startup** Routes: /mcp/<server> where <server> is one of: [github safeoutputs]
- ✓ **startup** TLS not configured — listening on http://0.0.0.0:8080 (set --tls-cert/--tls-key to enable)
- ✓ **shutdown** Shutting down gateway...

</details>
