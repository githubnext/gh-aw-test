# gh-aw-test

End-to-end tests for GitHub Agentic Workflows (gh-aw). Tests AI-powered workflows that automatically create issues, pull requests, and comments.

[![E2E Tests](https://github.com/githubnext/gh-aw-test/actions/workflows/e2e.yml/badge.svg)](https://github.com/githubnext/gh-aw-test/actions/workflows/e2e.yml)

## Quick Start

1. **Prerequisites**: [GitHub CLI](https://cli.github.com/), Git, authenticated GitHub account
2. **Clone**: `git clone https://github.com/githubnext/gh-aw-test.git && cd gh-aw-test`
3. **Authenticate**: `gh auth login`
4. **Run tests**:


## Usage

**Run all tests against the `main` branch of `gh-aw` using samples:**

```
./e2e.sh --use-samples --gh-aw-ref main test-copilot-*
```
**Run all tests using installed gh-aw with coding agent inference**
```bash
./e2e.sh
```

**Run specific tests:**
```bash
./e2e.sh test-claude-*               # All Claude tests
./e2e.sh test-*-create-issue         # All issue creation tests
./e2e.sh --dry-run                   # Preview without running
```
## Automated Testing

Nightly GitHub Actions run at 3:00 AM UTC. Manually trigger via Actions → "Nightly E2E Tests". Logs are available as downloadable artifacts.

Currently disabled.

## Troubleshooting

**Authentication issues**: Run `gh auth login` and `gh auth status`
**Missing gh-aw**: Script auto-builds it, or manually: `git clone https://github.com/github/gh-aw.git && cd gh-aw && make build`
**Timeouts**: Check log file `e2e-test-*.log` for details

## Safe Output Test Coverage

Tracking the full matrix of [safe outputs](https://github.com/github/gh-aw/blob/main/docs/src/content/docs/reference/safe-outputs.md) and [PR safe outputs](https://github.com/github/gh-aw/blob/main/docs/src/content/docs/reference/safe-outputs-pull-requests.md). New tests are copilot-only (claude/codex coverage already exists for the original set).

### Already Tested

- [x] `create-issue` — test-copilot-create-issue
- [x] `create-discussion` — test-copilot-create-discussion
- [x] `create-pull-request` — test-copilot-create-pull-request
- [x] `create-pull-request` (max:2) — test-copilot-create-two-pull-requests
- [x] `create-pull-request` (side-repo, depth-1 sparse checkout `src/` + `docs/`) — test-copilot-siderepo-sparse-create-pull-request
- [x] `create-code-scanning-alert` — test-copilot-create-repository-code-scanning-alert
- [x] `mcp` — test-copilot-mcp
- [x] `mcp` (`code_quality` toolset) — test-copilot-mcp-code-quality
- [x] `custom safe output jobs` — test-copilot-custom-safe-outputs
- [x] `gh-steps` — test-copilot-gh-steps
- [x] `add-comment` — test-copilot-add-comment
- [x] `add-comment` (discussions) — test-copilot-add-discussion-comment
- [x] `add-labels` — test-copilot-add-labels
- [x] `update-issue` — test-copilot-update-issue
- [x] `update-pull-request` — test-copilot-update-pull-request
- [x] `push-to-pull-request-branch` (slash-command) — test-copilot-push-to-pull-request-branch-using-slash-command
- [x] `push-to-pull-request-branch` (dispatch, local repo) — test-copilot-push-to-pull-request-branch-using-dispatch
- [x] `push-to-pull-request-branch` (dispatch, side-repo) — test-copilot-siderepo-push-to-pull-request-branch-using-dispatch
- [x] `push-to-pull-request-branch` (dispatch, side-repo, depth-1 sparse checkout `src/` + `docs/`) — test-copilot-siderepo-sparse-push-to-pull-request-branch-using-dispatch
- [x] `create-pull-request-review-comment` — test-copilot-create-pull-request-review-comment
- [x] `slash_command` + `add-comment` — test-copilot-command
- [x] `label_command` + `add-comment` — test-copilot-label-command

### Issues & Discussions — Remaining

- [x] `close-issue` — test-copilot-close-issue
- [x] `link-sub-issue` — test-copilot-link-sub-issue
- [x] `link-sub-issue` (side-repo, expression-based `allowed-repos`) — test-copilot-siderepo-link-sub-issue
- [x] `update-discussion` — test-copilot-update-discussion
- [x] `close-discussion` — test-copilot-close-discussion

### Pull Requests — Remaining

- [x] `close-pull-request` — test-copilot-close-pull-request
- [x] `reply-to-pull-request-review-comment` — test-copilot-reply-to-pull-request-review-comment
- [x] `resolve-pull-request-review-thread` — test-copilot-resolve-pull-request-review-thread
- [x] `submit-pull-request-review` — test-copilot-submit-pull-request-review
- [x] `submit-pull-request-review` (locked PR soft-skip) — test-copilot-submit-pull-request-review-locked
- [x] `add-reviewer` — test-copilot-add-reviewer
- [x] `mark-pull-request-as-ready-for-review` — test-copilot-mark-pull-request-as-ready-for-review
- [ ] `merge-pull-request` — cannot yet be sample-tested because the current workflow schema rejects `samples:` for `merge-pull-request`

### Labels, Assignments & Reviews — Remaining

- [x] `remove-labels` — test-copilot-remove-labels
- [x] `hide-comment` — test-copilot-hide-comment
- [x] `assign-milestone` — test-copilot-assign-milestone
- [x] `assign-to-agent` — test-copilot-assign-to-agent
- [x] `assign-to-user` — test-copilot-assign-to-user
- [x] `unassign-from-user` — test-copilot-unassign-from-user
- [x] `set-issue-type` — test-copilot-set-issue-type
- [x] `set-issue-field` — test-copilot-set-issue-field
- [x] `issue-intents` feature flag (`create-issue` with `features.issue-intents: true`) — test-copilot-issue-intents

### Security & Agent Tasks — Remaining

- [x] `dispatch-workflow` — test-copilot-dispatch-workflow
- [x] `call-workflow` — test-copilot-call-workflow (worker: test-copilot-call-worker)
- [x] `upload-asset` — test-copilot-upload-asset (auto-creates orphaned `assets/` branch)
- [ ] `upload-artifact` — test-copilot-upload-artifact
- [x] `noop` — test-copilot-noop
- [x] `report-incomplete` — test-copilot-report-incomplete
- [x] `create-check-run` — test-copilot-create-check-run
- [x] `update-release` — test-copilot-update-release

### Deferred (require special infrastructure)

- [ ] `create-agent-session` — requires Copilot coding agent access
- [ ] `create-project` / `update-project` / `create-project-status-update` — requires PAT with Projects permissions
- [ ] `upload-artifact` — needs a staged fixture file plus artifact-specific assertions in the harness
- [ ] `autofix-code-scanning-alert` — requires existing code scanning alerts
- [ ] `dispatch_repository` — experimental, requires cross-repo setup
- [ ] `missing-data` — system type, auto-enabled
- [ ] `merge-pull-request` — verified against `github/gh-aw@origin/main`: the workflow JSON schema still rejects `samples:` on `merge-pull-request` (the Go struct accepts it, but schema validation fails compile), so it cannot be sample-tested yet