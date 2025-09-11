# gh-aw-test

End-to-end tests for GitHub Agentic Workflows (gh-aw). Tests AI-powered workflows that automatically create issues, pull requests, and comments.

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
**Missing gh-aw**: Script auto-builds it, or manually: `git clone https://github.com/githubnext/gh-aw.git && cd gh-aw && make build`
**Timeouts**: Check log file `e2e-test-*.log` for details