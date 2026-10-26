import { readFileSync } from "node:fs";
import { createServer } from "node:https";

const [keyPath, certificatePath] = process.argv.slice(2);
const server = createServer({
  key: readFileSync(keyPath),
  cert: readFileSync(certificatePath),
}, (request, response) => {
  if (request.url === "/health") {
    response.writeHead(200).end("ok");
    return;
  }
  if (request.url !== "/mcp" || request.method !== "POST") {
    response.writeHead(404).end();
    return;
  }
  let body = "";
  request.on("data", chunk => { body += chunk; });
  request.on("end", () => {
    const message = JSON.parse(body);
    if (!Object.hasOwn(message, "id")) {
      response.writeHead(202).end();
      return;
    }
    let result = {};
    if (message.method === "initialize") {
      result = {
        protocolVersion: message.params?.protocolVersion ?? "2025-03-26",
        capabilities: { tools: {} },
        serverInfo: { name: "phase-a-custom-ca", version: "1.0.0" },
      };
    } else if (message.method === "tools/list") {
      result = {
        tools: [{
          name: "phase_a_marker",
          description: "Return the Phase A custom-CA marker",
          inputSchema: { type: "object", properties: {} },
        }],
      };
    } else if (message.method === "tools/call") {
      result = { content: [{ type: "text", text: "GH_AW_MCP_CUSTOM_CA_E2E" }] };
    }
    response.writeHead(200, { "content-type": "application/json" });
    response.end(JSON.stringify({ jsonrpc: "2.0", id: message.id, result }));
  });
});

server.listen(3443, "0.0.0.0");