# gh-aw-test

End-to-end tests for GitHub Agentic Workflows (gh-aw). Tests AI-powered workflows that automatically create issues, pull requests, and comments.

[![E2E Tests](https://github.com/githubnext/gh-aw-test/actions/workflows/e2e.yml/badge.svg)](https://github.com/githubnext/gh-aw-test/actions/workflows/e2e.yml)

## Quick Start

1. **Prerequisites**: [GitHub CLI](https://cli.github.com/), Git, authenticated GitHub account
2. **Clone**: `git clone https://github.com/githubnext/gh-aw-test.git && cd gh-aw-test`
3. **Authenticate**: `gh auth login`
4. **Run tests**: `./e2e.sh` (gh-aw binary will be auto-built if needed)

## Usage

**Run all tests:**
```bash
./e2e.sh
```

**Run specific test types:**
```bash
./e2e.sh --workflow-dispatch-only    # Direct workflow triggers
./e2e.sh --issue-triggered-only      # Tests via issue creation
./e2e.sh --command-triggered-only    # Tests via comments
```

**Run specific tests:**
```bash
./e2e.sh test-claude-*               # All Claude tests
./e2e.sh test-*-create-issue         # All issue creation tests
./e2e.sh --dry-run                   # Preview without running
```

## Test Types

- **Workflow dispatch**: AI creates issues, PRs, code scanning alerts, uses MCP tools
- **Issue-triggered**: AI adds comments and labels, updates issues
- **Command-triggered**: AI responds to commands, pushes code, adds review comments

## Automated Testing

Nightly GitHub Actions run at 3:00 AM UTC. Manually trigger via Actions → "Nightly E2E Tests". Logs are available as downloadable artifacts.

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
- [x] `create-code-scanning-alert` — test-copilot-create-repository-code-scanning-alert
- [x] `mcp` — test-copilot-mcp
- [x] `custom safe output jobs` — test-copilot-custom-safe-outputs
- [x] `gh-steps` — test-copilot-gh-steps
- [x] `add-comment` — test-copilot-add-comment
- [x] `add-comment` (discussions) — test-copilot-add-discussion-comment
- [x] `add-labels` — test-copilot-add-labels
- [x] `update-issue` — test-copilot-update-issue
- [x] `update-pull-request` — test-copilot-update-pull-request
- [x] `push-to-pull-request-branch` — test-copilot-push-to-pull-request-branch
- [x] `create-pull-request-review-comment` — test-copilot-create-pull-request-review-comment
- [x] `slash_command` + `add-comment` — test-copilot-command

### Issues & Discussions — Remaining

- [x] `close-issue` — test-copilot-close-issue
- [ ] `link-sub-issue` — test-copilot-link-sub-issue
- [ ] `update-discussion` — test-copilot-update-discussion
- [x] `close-discussion` — test-copilot-close-discussion

### Pull Requests — Remaining

- [x] `close-pull-request` — test-copilot-close-pull-request
- [ ] `reply-to-pull-request-review-comment` — test-copilot-reply-to-pull-request-review-comment
- [ ] `resolve-pull-request-review-thread` — test-copilot-resolve-pull-request-review-thread
- [ ] `submit-pull-request-review` — test-copilot-submit-pull-request-review
- [ ] `add-reviewer` — test-copilot-add-reviewer

### Labels, Assignments & Reviews — Remaining

- [x] `remove-labels` — test-copilot-remove-labels
- [ ] `hide-comment` — test-copilot-hide-comment
- [ ] `assign-milestone` — test-copilot-assign-milestone
- [ ] `assign-to-user` — test-copilot-assign-to-user
- [ ] `unassign-from-user` — test-copilot-unassign-from-user

### Security & Agent Tasks — Remaining

- [ ] `dispatch-workflow` — test-copilot-dispatch-workflow
- [ ] `call-workflow` — test-copilot-call-workflow

### Deferred (require special infrastructure)

- [ ] `assign-to-agent` — requires Copilot coding agent access
- [ ] `create-agent-session` — requires Copilot coding agent access
- [ ] `create-project` / `update-project` / `create-project-status-update` — requires PAT with Projects permissions
- [ ] `update-release` — requires existing releases
- [ ] `upload-asset` — requires orphaned branch setup
- [ ] `autofix-code-scanning-alert` — requires existing code scanning alerts
- [ ] `dispatch_repository` — experimental, requires cross-repo setup
- [ ] `missing-data` — system type, auto-enabled