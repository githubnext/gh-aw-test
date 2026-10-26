import { defineWorkflow, joinSession } from "@github/copilot-sdk/extension";
import { phaseAWorkflow } from "./workflow.mjs";

await joinSession({ workflows: [defineWorkflow(phaseAWorkflow)] });