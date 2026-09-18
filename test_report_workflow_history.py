#!/usr/bin/env python3
"""Tests for workflow-history timing extraction."""

import unittest

from report_workflow_history import copilot_phase_timings


class CopilotPhaseTimingsTests(unittest.TestCase):
    def test_splits_awf_harness_and_process(self):
        log = """
agent\tExecute GitHub Copilot CLI\t2026-09-02T03:21:05.500Z [entrypoint] Agentic Workflow Firewall - Agent Container
agent\tExecute GitHub Copilot CLI\t2026-09-02T03:21:12Z [copilot-harness] attempt 1: process started (pid=130)
agent\tExecute GitHub Copilot CLI\t2026-09-02T03:21:21.250Z [copilot-harness] attempt 1: process closed exitCode=0 duration=9s
"""
        self.assertEqual(
            copilot_phase_timings(log, "2026-09-02T03:20:38Z", "2026-09-02T03:21:25Z"),
            {
                "awf_startup_seconds": 27.5,
                "harness_startup_seconds": 6.5,
                "copilot_process_seconds": 9.25,
            },
        )

    def test_uses_first_start_and_final_close_across_retries(self):
        log = """
agent\tExecute GitHub Copilot CLI\t2026-09-02T03:20:40Z [entrypoint] Agentic Workflow Firewall - Agent Container
agent\tExecute GitHub Copilot CLI\t2026-09-02T03:20:42Z [copilot-harness] attempt 1: process started (pid=1)
agent\tExecute GitHub Copilot CLI\t2026-09-02T03:20:45Z [copilot-harness] attempt 1: process closed exitCode=1 duration=3s
agent\tExecute GitHub Copilot CLI\t2026-09-02T03:20:50Z [copilot-harness] attempt 2: process started (pid=2)
agent\tExecute GitHub Copilot CLI\t2026-09-02T03:20:54Z [copilot-harness] attempt 2: process closed exitCode=0 duration=4s
"""
        phases = copilot_phase_timings(log, "2026-09-02T03:20:38Z", "2026-09-02T03:21:00Z")
        self.assertEqual(phases["copilot_process_seconds"], 12.0)

    def test_ignores_markers_outside_step_and_handles_missing_log(self):
        log = "agent\tUNKNOWN STEP\t2026-09-02T03:19:00Z [entrypoint] Agentic Workflow Firewall - Agent Container"
        expected = {
            "awf_startup_seconds": None,
            "harness_startup_seconds": None,
            "copilot_process_seconds": None,
        }
        self.assertEqual(copilot_phase_timings(log, "2026-09-02T03:20:38Z", "2026-09-02T03:21:25Z"), expected)
        self.assertEqual(copilot_phase_timings(None, "2026-09-02T03:20:38Z", "2026-09-02T03:21:25Z"), expected)


if __name__ == "__main__":
    unittest.main()