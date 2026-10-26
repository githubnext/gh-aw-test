import readline from "node:readline";

await new Promise(resolve => setTimeout(resolve, Number(process.env.STARTUP_DELAY_MS ?? 0)));

const input = readline.createInterface({ input: process.stdin });
input.on("line", line => {
  const request = JSON.parse(line);
  let result = {};
  if (request.method === "initialize") {
    result = {
      protocolVersion: request.params?.protocolVersion ?? "2024-11-05",
      capabilities: { tools: {} },
      serverInfo: { name: "phase-a-delayed", version: "1.0.0" },
    };
  } else if (request.method === "tools/list") {
    result = {
      tools: [{
        name: "phase_a_marker",
        description: "Return the Phase A startup-timeout marker",
        inputSchema: { type: "object", properties: {} },
      }],
    };
  } else if (request.method === "tools/call") {
    result = {
      content: [{ type: "text", text: "GH_AW_MCP_STARTUP_TIMEOUT_E2E" }],
    };
  } else if (!Object.hasOwn(request, "id")) {
    return;
  }
  process.stdout.write(`${JSON.stringify({ jsonrpc: "2.0", id: request.id, result })}\n`);
});