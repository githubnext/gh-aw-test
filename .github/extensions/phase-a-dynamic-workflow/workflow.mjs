import { readFile } from "node:fs/promises";

export const phaseAWorkflow = {
  meta: {
    name: "phase-a-dynamic-workflow",
    description: "Validate a packaged fixture and return its marker. args: { marker: string }.",
    phases: [{ title: "Validate" }],
    argsSchema: {
      type: "object",
      required: ["marker"],
      properties: { marker: { type: "string" } },
    },
  },
  run: async context => {
    context.phase("Validate");
    const fixture = await context.step("load-fixture", async () => JSON.parse(
      await readFile(new URL("./support/.fixture.json", import.meta.url), "utf8"),
    ));
    if (context.args?.marker !== fixture.marker) {
      throw new Error("Dynamic workflow marker does not match the packaged fixture");
    }
    const result = await context.step("result", () => ({
      status: "PASS",
      marker: fixture.marker,
    }));
    context.log(`PASS: ${result.marker}`);
    return result;
  },
};