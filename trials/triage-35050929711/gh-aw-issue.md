## Summary

Daily AI Credits guardrail rejects legacy successful `--use-samples` runs created before #61053 because deterministic sample replay produced no billable engine usage, left `agent/token_usage.jsonl` empty, and did not include the new `agent/execution.json` evidence. A later run compiled after #61053 treats that legacy zero-cost artifact as missing accounting, fails activation, and skips the agent and safe-output jobs.

This caused a cascade across the `githubnext/gh-aw-test` E2E suite on gh-aw main.

PR #61053 was merged as `976492cdd111415c7196bc85f03f0aa343368c45` at `2026-09-15T22:01:51Z` and is an ancestor of the tested commit. It correctly preserves execution evidence for newly generated artifacts. The runs poisoning this guardrail window, such as `34927589119`, `34927991036`, and `34928383174`, ran around `2026-09-15T04:07–04:23Z`, before #61053 merged, and remained inside the rolling 24-hour window when this E2E ran.

## Reproduction

1. Before #61053, compile a workflow containing safe-output samples with `gh aw compile --use-samples` and run it successfully.
2. The deterministic replay path consumes zero AI Credits, but the resulting usage artifact has an empty `agent/token_usage.jsonl` and no `agent/execution.json` evidence.
3. After #61053, run the same workflow while the legacy successful sample run remains in the daily guardrail window.
4. Activation scans the legacy run and fails with:

```
Daily workflow AI Credits are unknown: Missing accounting for executed agent component in run <id> (attempt 1, job <id>, conclusion success): agent/token_usage.jsonl is empty; agent_usage.jsonl is missing; agent_usage.json is missing
```

Expected: a legacy successful deterministic sample replay is recognized as zero-cost, or otherwise does not block all subsequent runs during the #61053 rollout window.

Actual: `sumCoveredComponents` treats the successful agent/replay job as billable but unaccounted, reports `transient_error`, and fails activation.

## E2E evidence

- Parent E2E run: https://github.com/githubnext/gh-aw-test/actions/runs/35050929711
- gh-aw ref: `main` at `ac594b6525e3`
- Mode: source build, `--use-samples`; AI engine was not called
- Representative failure: https://github.com/githubnext/gh-aw-test/actions/runs/35051877133
- Activation job: https://github.com/githubnext/gh-aw-test/actions/runs/35051877133/job/104654054950
- Second representative failure: https://github.com/githubnext/gh-aw-test/actions/runs/35052488680/job/104656143402
- Nosandbox representative failure: https://github.com/githubnext/gh-aw-test/actions/runs/35053190247/job/104657957227

Representative log evidence from run `35051877133`, activation at `2026-09-16T03:31:34Z`:

```
[daily-workflow-aic] Inspected component accounting: {"runId":34927589119,"component":"agent","jobId":104249082281,"runAttempt":1,"conclusion":"success","candidates":[{"file":"agent/token_usage.jsonl","state":"empty"},...]}
[daily-workflow-aic] AIC inspection failed: {"status":"transient_error","error":"Missing accounting for executed agent component in run 34927589119 ... conclusion success: agent/token_usage.jsonl is empty; ..."}
##[error]Daily workflow AI Credits are unknown: Missing accounting for executed agent component ...
```

Affected started tests included:

- `test-copilot-add-discussion-comment`
- `test-copilot-close-issue`
- `test-copilot-add-labels`
- `test-copilot-add-comment`
- `test-copilot-assign-to-user`
- `test-copilot-close-discussion`
- `test-copilot-update-issue`
- `test-copilot-replace-label`
- `test-copilot-remove-labels`
- `test-copilot-update-discussion`
- `test-copilot-unassign-from-user`
- `test-copilot-assign-milestone`
- `test-copilot-mark-pull-request-as-ready-for-review`
- `test-copilot-add-reviewer`
- `test-copilot-close-pull-request`
- `test-copilot-update-pull-request`
- `test-copilot-nosandbox-add-labels`

Additional workflows remained queued behind the cascade until the test harness timed out and disabled them.

## Suggested fix

Add a narrowly scoped compatibility path for pre-#61053 successful sample artifacts, for example by recognizing legacy samples-mode workflow metadata alongside an empty authoritative agent accounting file. Avoid treating all empty successful accounting as zero, since that could hide real live-engine accounting failures. Newly generated artifacts should continue using the execution evidence added by #61053.

## Deduplication

Related: #61053 fixes this case for newly generated artifacts by preserving execution evidence. #61137 covers a failed agent job whose accounting file is entirely missing. This report is the remaining rollout gap for successful pre-#61053 samples-mode artifacts where the primary file exists but is empty and the new evidence is unavailable. Exact searches for `"conclusion success" "token_usage.jsonl is empty"` and samples/daily-AIC terms found no open duplicate.
