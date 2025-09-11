# gh-aw-test

This repository contains end-to-end tests for GitHub Agentic Workflows (gh-aw). It provides comprehensive testing of AI-powered workflows that can automatically create issues, pull requests, comments, and perform other GitHub actions.

## Overview

The repository includes:
- **e2e.sh** - A comprehensive end-to-end testing script
- **GitHub Actions workflow** - Automated nightly testing
- **Test workflows** - Various `.lock.yml` files that define different AI workflow scenarios

## Prerequisites

Before running tests locally, ensure you have:

1. **GitHub CLI (gh)** - Install from [cli.github.com](https://cli.github.com/)
2. **Git** - For cloning repositories and managing branches
3. **GitHub Authentication** - You'll need to be authenticated with appropriate permissions
4. **gh-aw binary** - The GitHub Agentic Workflows binary (see setup instructions below)

### Required Permissions

Your GitHub token needs the following permissions for this repository:
- Read access to repository contents
- Write access to issues and pull requests  
- Write access to repository (for creating branches)
- Read access to GitHub Actions

## Local Setup

### 1. Clone and Navigate to Repository

```bash
git clone https://github.com/githubnext/gh-aw-test.git
cd gh-aw-test
```

### 2. Authenticate GitHub CLI

```bash
gh auth login
```

Follow the prompts to authenticate. Verify authentication with:
```bash
gh auth status
```

### 3. Set Up gh-aw Binary

The e2e script can automatically handle the gh-aw binary in several ways:

**Option A: Use existing binary (if available)**
- If you have `gh-aw` binary at `./gh-aw`, it will be used automatically
- If you have it at `../gh-aw/gh-aw` (sibling checkout), it will be symlinked

**Option B: Automatic build (recommended)**
- The script will automatically clone and build gh-aw if not found locally
- This requires no manual setup - just run the tests

**Option C: Manual setup**
```bash
# Clone and build gh-aw manually
git clone https://github.com/githubnext/gh-aw.git gh-aw-src
cd gh-aw-src
make build
cd ..
ln -sf gh-aw-src/gh-aw ./gh-aw
```

## Running Tests

### Basic Usage

Run all tests:
```bash
./e2e.sh
```

### Test Types

The script supports three types of tests:

1. **Workflow Dispatch Tests** - Direct workflow triggers
   ```bash
   ./e2e.sh --workflow-dispatch-only
   ```

2. **Issue-Triggered Tests** - Tests triggered by creating issues
   ```bash
   ./e2e.sh --issue-triggered-only
   ```

3. **Command-Triggered Tests** - Tests triggered by issue/PR comments
   ```bash
   ./e2e.sh --command-triggered-only
   ```

### Specific Test Patterns

Run specific tests using pattern matching:
```bash
# Run only Claude tests
./e2e.sh test-claude-*

# Run only issue creation tests
./e2e.sh test-*-create-issue

# Run specific test
./e2e.sh test-claude-create-issue
```

### Dry Run

See what tests would run without executing them:
```bash
./e2e.sh --dry-run
```

### Common Options

```bash
./e2e.sh --help                    # Show help and usage
./e2e.sh --dry-run                 # Show what would be tested
./e2e.sh test-claude-* test-codex-* # Run specific patterns
```

## What the Tests Do

The e2e tests validate various AI workflow scenarios:

### Workflow Dispatch Tests
- **create-issue**: AI creates GitHub issues with specific labels
- **create-pull-request**: AI creates pull requests 
- **create-code-scanning-alert**: AI creates security alerts
- **mcp**: AI uses MCP (Model Context Protocol) tools

### Issue-Triggered Tests  
- **add-issue-comment**: AI responds to issues with comments
- **add-issue-labels**: AI adds labels to issues
- **update-issue**: AI updates issue titles, descriptions, and status

### Command-Triggered Tests
- **command**: AI responds to specific commands in issue comments
- **push-to-pr-branch**: AI pushes code changes to PR branches
- **create-pull-request-review-comment**: AI adds review comments to PRs

## Test Output

Tests generate:
- **Console output** with colored status indicators
- **Log file** (`e2e-test-YYYYMMDD-HHMMSS.log`) with detailed information
- **Final report** showing passed/failed/skipped tests

Example output:
```
✅ PASSED (8/10):
   ✓ test-claude-create-issue
   ✓ test-codex-create-issue
   ...

❌ FAILED (2/10):
   ✗ test-claude-mcp
   ✗ test-codex-mcp

📈 Success Rate: 80% (8/10)
```

## Automated Testing

### GitHub Actions Workflow

The repository includes automated testing via GitHub Actions (`.github/workflows/e2e.yml`):

- **Schedule**: Runs nightly at 3:00 AM UTC
- **Manual trigger**: Can be triggered via "Actions" → "Nightly E2E Tests" → "Run workflow"
- **Artifacts**: Test logs are uploaded as artifacts for debugging

### Monitoring Test Results

1. Go to the "Actions" tab in the GitHub repository
2. Select "Nightly E2E Tests" workflow
3. Click on a specific run to see results
4. Download the "e2e-output-log" artifact for detailed logs

## Troubleshooting

### Common Issues

**"GitHub CLI is not authenticated"**
```bash
gh auth login
gh auth status  # Verify authentication
```

**"gh-aw binary not found"**
- Let the script auto-build: it will clone and build gh-aw automatically
- Or manually build: `git clone https://github.com/githubnext/gh-aw.git && cd gh-aw && make build`

**"Not in the correct repository"**
- Ensure you're in the gh-aw-test directory
- The script validates you're in `githubnext/gh-aw-test`

**Tests timing out**
- Default timeout is 10 minutes per workflow
- Network issues or GitHub API rate limits can cause delays
- Check the log file for detailed error information

**Permission errors**
- Ensure your GitHub token has sufficient permissions
- You need write access to issues, PRs, and repository content

### Debug Mode

For detailed debugging, check the generated log file:
```bash
tail -f e2e-test-*.log  # Follow log in real-time
```

### Cleanup

The script automatically:
- Closes test issues and PRs after completion
- Deletes test branches
- Disables workflows after testing

Manual cleanup if needed:
```bash
# Close all open issues
gh issue list --json number --jq '.[].number' | xargs -I {} gh issue close {}

# Close all open PRs  
gh pr list --json number --jq '.[].number' | xargs -I {} gh pr close {}
```

## Contributing

When adding new tests:
1. Update the test functions in `e2e.sh`
2. Add corresponding workflow files in `.github/workflows/`
3. Update test patterns in the script
4. Test locally before committing

For questions or issues, please open a GitHub issue in this repository.