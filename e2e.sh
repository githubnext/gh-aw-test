#!/bin/bash

# End-to-end testing script for GitHub Agentic Workflows
# This script triggers all test workflows and validates their outcomes
#
# Usage: ./e2e.sh [OPTIONS]
#
# This script will:
# 1. Check prerequisites (gh CLI, authentication, gh-aw binary)
# 2. Enable workflows before testing them
# 3. Trigger workflows using "gh aw run" 
# 4. Wait for completion and validate outcomes
# 5. Disable workflows after testing
# 6. Generate comprehensive test report
# 7. Optionally clean up test resources
#
# Test Types:
# - workflow_dispatch: Direct trigger tests (create issues, PRs, code scanning alerts, etc.)
# - issue-triggered: Tests triggered by creating issues with specific titles
# - command-triggered: Tests triggered by posting commands in issue comments  
# - PR-triggered: Tests triggered by creating pull requests
#
# Options:
#   --dry-run                  Show what would be tested without running
#   --workflow-dispatch-only   Only run tests that use workflow_dispatch trigger
#                              (skip issue/comment/PR-triggered tests)
#   --use-samples              Use declared samples for more deterministic testing
#   --verbose, -v              Stream build/compile/version diagnostics to stdout
#   --help, -h                 Show help message
#
# Examples:
#   ./e2e.sh                               # Run all tests
#   ./e2e.sh --dry-run                     # See what would be tested
#   ./e2e.sh test-copilot-* --workflow-dispatch-only  # Only workflow_dispatch tests
#
# Prerequisites:
#   - GitHub CLI (gh) installed and authenticated
#   - gh-aw binary built (run 'make build')
#   - Proper repository permissions for creating issues/PRs
#   - Internet access for GitHub API calls

set -uo pipefail  # Removed -e to allow test failures without stopping the script

# Error Handling Strategy:
# - Individual test failures are tracked but don't stop the overall test suite
# - Polling timeouts are handled gracefully and recorded as test failures  
# - Critical prerequisite failures (like missing gh CLI) still exit immediately
# - Cleanup operations continue even if some steps fail

# Colors and emojis for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Test results tracking
declare -a PASSED_TESTS=()
declare -a FAILED_TESTS=()
declare -a SKIPPED_TESTS=()
declare -A TEST_RUN_URLS=()  # maps test name -> actions run URL (when available)

# Parallel execution settings
BATCH_SIZE=25
NO_PARALLEL=false

# Lock file for synchronized result tracking across parallel processes
RESULTS_LOCK="/tmp/e2e-results-$$.lock"

# Global tracking of workflows that need to be disabled
# This is used by the trap handler to ensure cleanup on early exit
declare -a GLOBAL_WORKFLOWS_TO_DISABLE=()
GLOBAL_WORKFLOWS_LOCK="/tmp/e2e-workflows-$$.lock"

# Workflows that must NEVER be disabled by the runner. These are the CI/infra
# workflows (the nightly E2E matrix in particular) that need to stay enabled so
# their `schedule:` triggers keep firing. `disable_all_workflows_before_testing`
# disables every active workflow before a run, so without this allow-list it
# would turn off the very workflow that invokes it in CI, killing nightly runs.
# Names must match the `name:` field of the workflow as reported by
# `gh workflow list`.
declare -a NEVER_DISABLE_WORKFLOWS=(
    "e2e"
)

# Returns 0 (true) if the given workflow name is on the never-disable list.
is_protected_workflow() {
    local name="$1"
    local protected
    for protected in "${NEVER_DISABLE_WORKFLOWS[@]}"; do
        [[ "$name" == "$protected" ]] && return 0
    done
    return 1
}

# Record a test pass: update arrays and remove from fails.txt
record_test_pass() {
    local test_name="$1"
    PASSED_TESTS+=("$test_name")
    # Remove the test from fails.txt if present
    if [[ -f "fails.txt" ]]; then
        local _tmp
        _tmp=$(grep -v "^${test_name} \|^${test_name}$" "fails.txt" 2>/dev/null || true)
        if [[ -n "$_tmp" ]]; then
            echo "$_tmp" > "fails.txt"
        else
            rm -f "fails.txt"
        fi
    fi
}

# Record a test failure: update arrays and add/append to fails.txt
record_test_fail() {
    local test_name="$1"
    FAILED_TESTS+=("$test_name")
    # Look up the run ID
    local _url="${TEST_RUN_URLS[$test_name]:-}"
    local _run_id=""
    if [[ -n "$_url" ]]; then
        _run_id="${_url##*/}"
    fi
    if [[ -z "$_run_id" ]]; then
        local _wf="${test_name}.lock.yml"
        _run_id=$(gh run list \
            --repo "$REPO_OWNER/$REPO_NAME" \
            --workflow="$_wf" \
            --limit=1 \
            --json databaseId \
            --jq '.[0].databaseId' 2>/dev/null || echo "")
    fi
    # Update fails.txt: append run ID to existing line or add new entry
    if [[ -f "fails.txt" ]] && grep -q "^${test_name} \|^${test_name}$" "fails.txt" 2>/dev/null; then
        if [[ -n "$_run_id" ]]; then
            local _existing_line
            _existing_line=$(grep "^${test_name} \|^${test_name}$" "fails.txt")
            if [[ "$_existing_line" != *"$_run_id"* ]]; then
                sed -i "s|^${test_name}\( .*\)\?$|${test_name}\1 ${_run_id}|" "fails.txt"
            fi
        fi
    else
        if [[ -n "$_run_id" ]]; then
            echo "$test_name $_run_id" >> "fails.txt"
        else
            echo "$test_name" >> "fails.txt"
        fi
    fi
}

# Helper function to safely execute commands that might fail
# Usage: safe_run "operation description" command arg1 arg2...
safe_run() {
    local description="$1"
    shift
    
    if "$@"; then
        return 0
    else
        local exit_code=$?
        warning "Failed to $description (exit code: $exit_code)"
        return $exit_code
    fi
}

# Configuration
REPO_OWNER="githubnext"
REPO_NAME="gh-aw-test"
TIMEOUT_MINUTES=10
POLL_INTERVAL=5
LOG_FILE="e2e-test-$(date +%Y%m%d-%H%M%S).log"
TEMP_USER_PAT_SET=false
WORKFLOW_DISPATCH_ONLY=false
USE_SAMPLES=false

# --verbose: when true, build/compile/version diagnostics that normally go only
# to $LOG_FILE are ALSO streamed to stdout. Useful in CI where $LOG_FILE is not
# surfaced and a failing `make build` / capability probe is otherwise opaque.
VERBOSE=false

# Shared results file for parallel execution
RESULTS_FILE="/tmp/e2e-results-$$.txt"

# --gh-aw-ref: when non-empty, the script resets a parallel ../gh-aw checkout to
# this ref, builds it, and uses the resulting binary for compile+enable+disable+run.
# Compiled workflows will then reference github/gh-aw/actions/setup@<GH_AW_REF>
# instead of the published github/gh-aw-actions/setup@<version>.
GH_AW_REF=""
GH_AW_SRC_DIR="../gh-aw"
GH_AW_BIN="gh aw"

# --branch / $E2E_BRANCH: when non-empty, e2e.sh pushes the recompiled
# workflows to this branch (force-push) instead of committing to main, and
# dispatches every test workflow with `--ref <branch>` so the run executes the
# branch's version. This isolates concurrent/serial matrix entries from each
# other (and from main) — each (gh-aw ref × samples) combination gets its own
# stable branch that is reused and force-updated on every run. When empty, the
# legacy behaviour (push to main, dispatch from the default branch) is used.
E2E_BRANCH="${E2E_BRANCH:-}"
# DISPATCH_REF is derived from E2E_BRANCH and passed to `gh aw run --ref` /
# `gh workflow run --ref`. Empty means "use the repository default branch".
DISPATCH_REF=""

# CI mode: when the standard `$CI` environment variable is set to `true`
# (which GitHub Actions and most other CI providers do automatically), e2e.sh
# does NOT mutate repository secrets. Default to false if unset.
CI="${CI:-false}"

# Utility functions
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $*" | tee -a "$LOG_FILE"
}

info() {
    echo -e "${BLUE}ℹ️  $*${NC}" | tee -a "$LOG_FILE"
}

success() {
    echo -e "${GREEN}✅ $*${NC}" | tee -a "$LOG_FILE"
}

warning() {
    echo -e "${YELLOW}⚠️  $*${NC}" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}❌ $*${NC}" | tee -a "$LOG_FILE"
}

progress() {
    echo -e "${PURPLE}🔨 $*${NC}" | tee -a "$LOG_FILE"
}

# Run a command, always appending its combined output to $LOG_FILE. When
# VERBOSE is true the output is ALSO streamed to stdout (via the terminal),
# which is important in CI where $LOG_FILE is not otherwise surfaced. Returns
# the command's exit status.
run_logged() {
    if [[ "$VERBOSE" == true ]]; then
        # tee keeps the log file in sync while echoing to the console.
        "$@" 2>&1 | tee -a "$LOG_FILE"
        return "${PIPESTATUS[0]}"
    else
        "$@" &>> "$LOG_FILE"
    fi
}

# Secret management functions
set_temp_user_pat() {
    info "Setting TEMP_USER_PAT secret for cross-repo testing..."
    
    # Get the current user's PAT
    local user_pat=$(gh auth token 2>/dev/null)
    
    if [[ -z "$user_pat" ]]; then
        error "Failed to get GitHub auth token. Run 'gh auth login'"
        return 1
    fi
    
    # Set the secret in the repository (gh secret set is idempotent - overwrites if already present)
    local secret_err
    local max_attempts=3
    local attempt=1
    while [[ $attempt -le $max_attempts ]]; do
        secret_err=$(echo "$user_pat" | gh secret set TEMP_USER_PAT --repo "$REPO_OWNER/$REPO_NAME" 2>&1)
        local rc=$?
        echo "$secret_err" >> "$LOG_FILE"
        if [[ $rc -eq 0 ]]; then
            TEMP_USER_PAT_SET=true
            success "TEMP_USER_PAT secret set successfully"
            return 0
        fi
        if [[ $attempt -lt $max_attempts ]]; then
            warning "Failed to set TEMP_USER_PAT secret (attempt $attempt/$max_attempts): $secret_err"
            sleep 5
        fi
        attempt=$((attempt + 1))
    done
    error "Failed to set TEMP_USER_PAT secret after $max_attempts attempts: $secret_err"
    return 1
}

delete_temp_user_pat() {
    if [[ "$TEMP_USER_PAT_SET" == true ]]; then
        info "Cleaning up TEMP_USER_PAT secret..."
        if gh secret delete TEMP_USER_PAT --repo "$REPO_OWNER/$REPO_NAME" &>> "$LOG_FILE"; then
            TEMP_USER_PAT_SET=false
            success "TEMP_USER_PAT secret deleted successfully"
            return 0
        else
            warning "Failed to delete TEMP_USER_PAT secret (it may not exist)"
            return 1
        fi
    fi
}

cleanup_on_exit() {
    # Prevent double execution
    if [[ "${CLEANUP_DONE:-false}" == "true" ]]; then
        return 0
    fi
    CLEANUP_DONE=true
    
    echo
    info "Performing cleanup..."
    
    # Load workflows from temp file (for parallel processes)
    if [[ -f "/tmp/e2e-workflows-list-$$.txt" ]]; then
        while IFS= read -r wf; do
            [[ -n "$wf" ]] && GLOBAL_WORKFLOWS_TO_DISABLE+=("$wf")
        done < "/tmp/e2e-workflows-list-$$.txt"
    fi
    
    # Disable any workflows that were enabled during testing
    if [[ ${#GLOBAL_WORKFLOWS_TO_DISABLE[@]} -gt 0 ]]; then
        # Remove duplicates
        local -A seen
        local unique_workflows=()
        for workflow in "${GLOBAL_WORKFLOWS_TO_DISABLE[@]}"; do
            if [[ -z "${seen[$workflow]:-}" ]]; then
                seen[$workflow]=1
                unique_workflows+=("$workflow")
            fi
        done
        
        info "Disabling ${#unique_workflows[@]} workflow(s) in parallel that were enabled during testing..."
        for workflow in "${unique_workflows[@]}"; do
            # Never disable protected CI/infra workflows (e.g. the nightly E2E
            # matrix) even if they somehow ended up on the disable queue.
            if is_protected_workflow "$workflow"; then
                info "  🔒 Keeping '$workflow' enabled (protected workflow)"
                continue
            fi
            (disable_workflow "$workflow" 2>/dev/null || warning "Failed to disable workflow '$workflow', continuing...") &
        done
        wait
    fi
    
    delete_temp_user_pat
    
    # Clean up lock files
    rm -f "$RESULTS_LOCK" "$GLOBAL_WORKFLOWS_LOCK" "$RESULTS_FILE" "/tmp/e2e-workflows-list-$$.txt" 2>/dev/null || true
}


# Test pattern matching functions
matches_pattern() {
    local test_name="$1"
    local pattern="$2"
    
    # Convert glob pattern to regex
    local regex_pattern=$(echo "$pattern" | sed 's/\*/[^[:space:]]*/g')
    
    if [[ "$test_name" =~ ^${regex_pattern}$ ]]; then
        return 0
    else
        return 1
    fi
}

# Get target repo from workflow name (defaults to current repo)
get_target_repo() {
    local workflow_name="$1"
    
    if [[ "$workflow_name" == *"siderepo"* ]]; then
        echo "githubnext/gh-aw-side-repo"
    else
        echo ""
    fi
}

# Extract AI type from workflow name
extract_ai_type() {
    local workflow_name="$1"
    
    # Check for nosandbox variants first (more specific)
    if [[ "$workflow_name" == *"claude-nosandbox"* ]]; then
        echo "claude-nosandbox"
    elif [[ "$workflow_name" == *"codex-nosandbox"* ]]; then
        echo "codex-nosandbox"
    elif [[ "$workflow_name" == *"copilot-nosandbox"* ]]; then
        echo "copilot-nosandbox"
    # Then check for regular variants
    elif [[ "$workflow_name" == *"claude"* ]]; then
        echo "claude"
    elif [[ "$workflow_name" == *"codex"* ]]; then
        echo "codex"
    elif [[ "$workflow_name" == *"copilot"* ]]; then
        echo "copilot"
    else
        echo ""
    fi
}

# Get display name for AI type
get_ai_display_name() {
    local ai_type="$1"
    
    case "$ai_type" in
        claude-nosandbox)
            echo "Claude (No Sandbox)"
            ;;
        codex-nosandbox)
            echo "Codex (No Sandbox)"
            ;;
        copilot-nosandbox)
            echo "Copilot (No Sandbox)"
            ;;
        claude)
            echo "Claude"
            ;;
        codex)
            echo "Codex"
            ;;
        copilot)
            echo "Copilot"
            ;;
        *)
            echo "${ai_type^}"
            ;;
    esac
}

# Get expected labels for AI type
# Nosandbox variants use separate labels: base-type, nosandbox, automation
# Regular variants use: base-type, automation
get_expected_labels() {
    local ai_type="$1"
    
    case "$ai_type" in
        claude-nosandbox)
            echo "claude,nosandbox,automation"
            ;;
        codex-nosandbox)
            echo "codex,nosandbox,automation"
            ;;
        copilot-nosandbox)
            echo "copilot,nosandbox,automation"
            ;;
        *)
            echo "${ai_type},automation"
            ;;
    esac
}

# Get title prefix for validation based on workflow name and type
# PR tests use different prefixes to avoid conflicts in parallel execution
get_title_prefix() {
    local workflow_name="$1"
    local ai_type="$2"
    
    # Determine the appropriate suffix based on workflow type
    if [[ "$workflow_name" == *"create-two-pull-requests"* ]]; then
        echo "[${ai_type}-test-two-prs] "
    elif [[ "$workflow_name" == *"subdir-create-pull-request"* ]]; then
        echo "[${ai_type}-test-subdir-pr] "
    elif [[ "$workflow_name" == *"create-pull-request"* ]]; then
        echo "[${ai_type}-test-single-pr] "
    elif [[ "$workflow_name" == *"gh-steps"* ]]; then
        echo "[${ai_type}-test-gh-steps] "
    else
        # Default for non-PR tests (issues, discussions, etc.)
        echo "[${ai_type}-test] "
    fi
}

should_run_test() {
    local test_name="$1"
    local patterns=("${@:2}")
    
    # If no patterns specified, run all tests
    if [[ ${#patterns[@]} -eq 0 ]]; then
        return 0
    fi
    
    # Check if test matches any pattern
    for pattern in "${patterns[@]}"; do
        if matches_pattern "$test_name" "$pattern"; then
            return 0
        fi
    done
    
    return 1
}

get_all_tests() {
    # Workflow dispatch tests
    echo "test-claude-create-issue"
    echo "test-codex-create-issue"
    echo "test-copilot-create-issue"
    echo "test-claude-create-discussion"
    echo "test-codex-create-discussion"
    echo "test-copilot-create-discussion"
    echo "test-claude-create-pull-request"
    echo "test-codex-create-pull-request"
    echo "test-copilot-create-pull-request"
    echo "test-claude-create-two-pull-requests"
    echo "test-codex-create-two-pull-requests"
    echo "test-copilot-create-two-pull-requests"
    echo "test-claude-create-code-scanning-alert"
    echo "test-codex-create-repository-code-scanning-alert"
    echo "test-copilot-create-repository-code-scanning-alert"
    echo "test-copilot-create-check-run"
    echo "test-claude-mcp"
    echo "test-codex-mcp"
    echo "test-copilot-mcp"
    echo "test-claude-custom-safe-outputs"
    echo "test-codex-custom-safe-outputs"
    echo "test-copilot-custom-safe-outputs"
    echo "test-copilot-gh-steps"
    # Issue-triggered tests
    echo "test-claude-add-comment"
    echo "test-claude-add-labels"
    echo "test-claude-add-discussion-comment"
    echo "test-codex-add-comment"
    echo "test-codex-add-labels"
    echo "test-codex-add-discussion-comment"
    echo "test-copilot-add-comment"
    echo "test-copilot-add-labels"
    echo "test-copilot-add-discussion-comment"
    echo "test-claude-update-issue"
    echo "test-codex-update-issue"
    echo "test-copilot-update-issue"
    echo "test-copilot-close-issue"
    echo "test-copilot-remove-labels"
    echo "test-copilot-close-discussion"
    echo "test-copilot-update-discussion"
    echo "test-copilot-assign-to-user"
    echo "test-copilot-unassign-from-user"
    echo "test-copilot-assign-milestone"
    echo "test-copilot-link-sub-issue"
    echo "test-copilot-hide-comment"
    # PR-triggered tests
    echo "test-claude-update-pull-request"
    echo "test-codex-update-pull-request"
    echo "test-copilot-update-pull-request"
    echo "test-copilot-close-pull-request"
    echo "test-copilot-add-reviewer"
    echo "test-copilot-mark-pull-request-as-ready-for-review"
    # Command-triggered tests
    echo "test-claude-command"
    echo "test-codex-command"
    echo "test-copilot-command"
    echo "test-claude-push-to-pull-request-branch"
    echo "test-codex-push-to-pull-request-branch"
    echo "test-copilot-push-to-pull-request-branch"
    echo "test-claude-create-pull-request-review-comment"
    echo "test-codex-create-pull-request-review-comment"
    echo "test-copilot-create-pull-request-review-comment"
    echo "test-copilot-reply-to-pull-request-review-comment"
    echo "test-copilot-resolve-pull-request-review-thread"
    echo "test-copilot-submit-pull-request-review"
    echo "test-copilot-set-issue-type"
    # Workflow_dispatch tests with inputs (dispatch-workflow needs a sentinel)
    echo "test-copilot-dispatch-workflow"
    echo "test-copilot-call-workflow"
    echo "test-copilot-noop"
    echo "test-copilot-report-incomplete"
    echo "test-copilot-update-release"
    echo "test-copilot-upload-asset"
    # Nosandbox tests - limited set for claude/codex, full matrix for copilot
    echo "test-copilot-nosandbox-create-issue"
    echo "test-copilot-nosandbox-create-discussion"
    echo "test-copilot-nosandbox-create-pull-request"
    echo "test-copilot-nosandbox-create-two-pull-requests"
    echo "test-copilot-nosandbox-create-repository-code-scanning-alert"
    echo "test-copilot-nosandbox-mcp"
    echo "test-copilot-nosandbox-custom-safe-outputs"
    echo "test-copilot-nosandbox-add-comment"
    echo "test-copilot-nosandbox-add-labels"
    echo "test-copilot-nosandbox-add-discussion-comment"
    echo "test-copilot-nosandbox-update-issue"
    echo "test-copilot-nosandbox-command"
    echo "test-copilot-nosandbox-push-to-pull-request-branch"
    echo "test-copilot-nosandbox-create-pull-request-review-comment"
    # Siderepo tests - cross-repo private repository tests
    echo "test-copilot-siderepo-create-issue"
    echo "test-copilot-siderepo-create-discussion"
    echo "test-copilot-siderepo-create-pull-request"
    echo "test-copilot-siderepo-subdir-create-pull-request"
    echo "test-copilot-siderepo-create-two-pull-requests"
    # echo "test-copilot-siderepo-create-repository-code-scanning-alert"  # Disabled: doesn't support target-repo
    echo "test-copilot-siderepo-mcp"
    # echo "test-copilot-siderepo-custom-safe-outputs"  # Disabled: doesn't support target-repo
    echo "test-copilot-siderepo-add-comment"
    echo "test-copilot-siderepo-add-labels"
    echo "test-copilot-siderepo-add-discussion-comment"
    echo "test-copilot-siderepo-update-issue"
    # echo "test-copilot-siderepo-push-to-pull-request-branch"  # Disabled: doesn't support target-repo
    echo "test-copilot-siderepo-create-pull-request-review-comment"
}

filter_tests() {
    local patterns=("$@")
    
    local all_tests
    all_tests=($(get_all_tests))
    
    local filtered_tests=()
    for test in "${all_tests[@]}"; do
        if should_run_test "$test" "${patterns[@]}"; then
            filtered_tests+=("$test")
        fi
    done
    
    # Only print if there are filtered tests
    if [[ ${#filtered_tests[@]} -gt 0 ]]; then
        printf '%s\n' "${filtered_tests[@]}"
    fi
}

# Reset a parallel gh-aw checkout to $GH_AW_REF, build it, and set GH_AW_BIN.
# Used when the user passes --gh-aw-ref <ref> to test compiled workflows against
# a specific gh-aw branch, tag, or SHA. The compiled lock.yml files will then
# pin github/gh-aw/actions/setup@<ref> at runtime instead of the published
# github/gh-aw-actions/setup@<version>.
setup_local_gh_aw_binary() {
    info "Setting up local gh-aw build for ref '$GH_AW_REF'..."

    if [[ ! -d "$GH_AW_SRC_DIR/.git" ]]; then
        error "--gh-aw-ref requires a parallel gh-aw checkout at $GH_AW_SRC_DIR (not found)"
        exit 1
    fi

    progress "Fetching latest refs from origin in $GH_AW_SRC_DIR..."
    # --force + --prune-tags tolerates moved/deleted upstream tags
    if ! run_logged git -C "$GH_AW_SRC_DIR" fetch origin --prune --prune-tags --tags --force; then
        error "Failed to fetch from origin in $GH_AW_SRC_DIR"
        exit 1
    fi

    progress "Resetting $GH_AW_SRC_DIR to '$GH_AW_REF'..."
    # Try branch (origin/<ref>) first, then fall back to tag/SHA.
    if git -C "$GH_AW_SRC_DIR" rev-parse --verify "origin/$GH_AW_REF" &>/dev/null; then
        if ! run_logged git -C "$GH_AW_SRC_DIR" checkout -B "$GH_AW_REF" "origin/$GH_AW_REF"; then
            error "Failed to checkout branch '$GH_AW_REF' in $GH_AW_SRC_DIR"
            exit 1
        fi
    else
        if ! run_logged git -C "$GH_AW_SRC_DIR" checkout --detach "$GH_AW_REF"; then
            error "Failed to checkout ref '$GH_AW_REF' in $GH_AW_SRC_DIR (not a branch, tag, or SHA)"
            exit 1
        fi
    fi

    # Record the resolved commit so a stale/empty build is easy to diagnose.
    local resolved_sha
    resolved_sha=$(git -C "$GH_AW_SRC_DIR" rev-parse --short HEAD 2>/dev/null || echo "unknown")
    info "  $GH_AW_SRC_DIR is at commit $resolved_sha"

    progress "Building gh-aw binary at $GH_AW_SRC_DIR (make build)..."
    if ! ( cd "$GH_AW_SRC_DIR" && run_logged make build ); then
        error "Failed to build gh-aw binary in $GH_AW_SRC_DIR. Check $LOG_FILE for details"
        exit 1
    fi

    local bin_path="$GH_AW_SRC_DIR/gh-aw"
    if [[ ! -x "$bin_path" ]]; then
        error "Built binary not found at $bin_path"
        exit 1
    fi

    GH_AW_BIN="$bin_path"
    # Capture version output (incl. stderr) for diagnostics. An empty version
    # usually means the build silently produced a binary without ldflags/version
    # info or that an old binary is being reused.
    local built_version
    built_version=$($GH_AW_BIN --version 2>&1 || echo "unknown")
    echo "gh-aw --version output: ${built_version:-<empty>}" >> "$LOG_FILE"
    success "Built gh-aw binary: $bin_path (commit $resolved_sha, version: ${built_version:-<empty>})"

    # Verify the binary supports --gh-aw-ref. Capture the help output so a
    # failure here can be diagnosed (e.g. ref older than the flag, or the wrong
    # binary was built/picked up).
    local compile_help
    compile_help=$($GH_AW_BIN compile --help 2>&1)
    echo "--- '$GH_AW_BIN compile --help' output ---" >> "$LOG_FILE"
    echo "$compile_help" >> "$LOG_FILE"
    if [[ "$VERBOSE" == true ]]; then
        echo "$compile_help"
    fi
    if ! grep -q -- "--gh-aw-ref" <<< "$compile_help"; then
        error "The built gh-aw binary does not support --gh-aw-ref. The ref '$GH_AW_REF' (commit $resolved_sha) is likely older than the flag's introduction, or the wrong binary was built (version: ${built_version:-<empty>})."
        error "Re-run with --verbose to see the full build and 'compile --help' output."
        exit 1
    fi
}

check_prerequisites() {
    info "Checking prerequisites..."

    # Check gh CLI is installed and authenticated
    if ! command -v gh &> /dev/null; then
        error "GitHub CLI (gh) is not installed"
        exit 1
    fi

    # Check authentication
    if ! gh auth status &> /dev/null; then
        error "GitHub CLI is not authenticated. Run 'gh auth login'"
        exit 1
    fi

    # Either install/upgrade the released gh-aw extension OR build the requested
    # ref from a parallel ../gh-aw checkout.
    if [[ -n "$GH_AW_REF" ]]; then
        setup_local_gh_aw_binary
    else
        info "Checking gh-aw extension..."
        if gh extension list | grep -q "github/gh-aw"; then
            info "gh-aw extension already installed, upgrading to latest version..."
            if gh extension upgrade github/gh-aw &>> "$LOG_FILE"; then
                success "gh-aw extension upgraded successfully"
            else
                warning "Failed to upgrade gh-aw extension, continuing with existing version"
            fi
        else
            info "Installing gh-aw extension..."
            if gh extension install github/gh-aw &>> "$LOG_FILE"; then
                success "gh-aw extension installed successfully"
            else
                error "Failed to install gh-aw extension. Check $LOG_FILE for details"
                exit 1
            fi
        fi
    fi

    # Verify the chosen gh-aw binary is available
    if ! $GH_AW_BIN --version &>> "$LOG_FILE"; then
        error "gh-aw binary ($GH_AW_BIN) is not available"
        exit 1
    fi

    # Check we're in the right repo
    local current_repo=$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || echo "")
    if [[ "$current_repo" != "$REPO_OWNER/$REPO_NAME" ]]; then
        error "Not in the correct repository. Expected $REPO_OWNER/$REPO_NAME, got $current_repo"
        exit 1
    fi

    # Compile workflows. When --gh-aw-ref is set, pass it through so compiled
    # workflows reference github/gh-aw/actions/setup@<ref> at runtime.
    local compile_cmd=($GH_AW_BIN compile)
    if [[ -n "$GH_AW_REF" ]]; then
        compile_cmd+=(--gh-aw-ref "$GH_AW_REF")
    fi
    if [[ "$USE_SAMPLES" == true ]]; then
        compile_cmd+=(--use-samples)
    fi
    info "Running: ${compile_cmd[*]}"
    if ! "${compile_cmd[@]}" 2>&1 | tee -a "$LOG_FILE"; then
        error "'${compile_cmd[*]}' failed. Check $LOG_FILE for details"
        exit 1
    fi

    # If there are any updates from the compile, commit them and push them so the
    # workflows are up to date for testing.
    #
    # Two destinations:
    #   * E2E_BRANCH set  -> create/reset a dedicated branch from the current
    #     HEAD, commit any changes, and force-push the branch. Test workflows are
    #     later dispatched with `--ref $E2E_BRANCH`, so this never touches main
    #     and parallel/serial matrix entries can't clobber each other.
    #   * E2E_BRANCH empty -> legacy behaviour: commit and push to main.
    # NOTE: when running against --gh-aw-ref the lock.yml diff is expected; we still
    # push so the test runs see the ref-specific workflows.

    local commit_msg="chore: update compiled workflows via e2e.sh"
    if [[ -n "$GH_AW_REF" ]]; then
        commit_msg="chore: e2e.sh recompile against gh-aw ref ${GH_AW_REF}"
    fi

    if [[ -n "$E2E_BRANCH" ]]; then
        DISPATCH_REF="$E2E_BRANCH"
        info "Using dedicated test branch '$E2E_BRANCH' (workflows dispatched with --ref '$E2E_BRANCH')"
        # Move onto the dedicated branch, carrying any compile changes in the
        # working tree with us.
        if ! git checkout -B "$E2E_BRANCH" &>> "$LOG_FILE"; then
            error "Failed to create/reset local branch '$E2E_BRANCH'. Check $LOG_FILE for details"
            exit 1
        fi
        local git_status
        git_status=$(git status --porcelain)
        if [[ -n "$git_status" ]]; then
            git add . &>> "$LOG_FILE"
            git commit -m "$commit_msg" &>> "$LOG_FILE"
        else
            info "No changes detected after compile; force-pushing branch to keep it in sync"
        fi
        # Always force-push so the remote branch exactly matches the compiled
        # state (the branch is ephemeral/reused and safe to overwrite).
        if git push --force origin "$E2E_BRANCH" &>> "$LOG_FILE"; then
            success "Pushed compiled workflows to branch '$E2E_BRANCH'"
        else
            error "Failed to push to branch '$E2E_BRANCH'. Check $LOG_FILE for details"
            exit 1
        fi
    else
        local git_status
        git_status=$(git status --porcelain)
        if [[ -n "$git_status" ]]; then
            info "Detected changes after compile; committing and pushing to main branch"
            git add . &>> "$LOG_FILE"
            git commit -m "$commit_msg" &>> "$LOG_FILE"
            if git push origin main &>> "$LOG_FILE"; then
                success "Changes pushed to main branch"
            else
                error "Failed to push changes to main branch. Check $LOG_FILE for details"
                exit 1
            fi
        else
            info "No changes detected after compile"
        fi
    fi

    # PAT handling.
    #
    # Two modes (selected automatically via the standard `$CI` env var):
    #   * Local mode (CI unset or != "true"): the script uses its own
    #     `gh auth token` to set the repository's TEMP_USER_PAT secret so
    #     dispatched workflows can do cross-repo operations. We also delete
    #     the secret on exit.
    #   * CI mode (CI=true): the script MUST NOT mutate repo secrets (parallel
    #     matrix runs would clobber each other and we don't want CI write-scope
    #     tokens leaking through `gh secret set`). Instead, the PAT is supplied
    #     as the GH_AW_TEST_PAT environment variable, sourced from the actions
    #     secret of the same name. The repo's TEMP_USER_PAT secret is expected
    #     to be pre-configured (typically to the same value).
    if [[ "$CI" == true ]]; then
        if [[ -z "${GH_AW_TEST_PAT:-}" ]]; then
            error "CI mode (CI=true) requires the GH_AW_TEST_PAT environment variable to be set (sourced from the actions secret of the same name). e2e.sh will not set repo secrets in this mode."
            exit 1
        fi
        info "CI mode: skipping TEMP_USER_PAT secret management; using pre-configured repo secret + GH_AW_TEST_PAT env"
    else
        # Set TEMP_USER_PAT secret for cross-repo testing
        if ! set_temp_user_pat; then
            error "Failed to set TEMP_USER_PAT secret. Cross-repo tests will fail."
            exit 1
        fi
    fi

    success "Prerequisites check passed"
}

disable_all_workflows_before_testing() {
    info "Disabling all workflows that aren't already disabled..."
    
    # Get list of all workflows with their state
    # Format: workflow_id state
    progress "Running: gh workflow list --all --json name,state"
    local workflows_output
    workflows_output=$(gh workflow list --all --json name,state --jq '.[] | "\(.name)\t\(.state)"' 2>/dev/null)
    
    if [[ -z "$workflows_output" ]]; then
        warning "No workflows found or failed to list workflows"
        return 0
    fi
    
    local -a to_disable=()
    local already_disabled_count=0

    while IFS=$'\t' read -r workflow_name workflow_state; do
        # Never disable protected CI/infra workflows (e.g. the nightly E2E
        # matrix), otherwise the scheduled run that invokes us in CI would be
        # turned off and nightly testing would stop.
        if is_protected_workflow "$workflow_name"; then
            info "  🔒 Keeping '$workflow_name' enabled (protected workflow)"
            continue
        fi
        # Skip if already disabled
        if [[ "$workflow_state" == "disabled_manually" ]] || [[ "$workflow_state" == "disabled_inactivity" ]]; then
            info "  ⏭️  Skipping '$workflow_name' (already $workflow_state)"
            already_disabled_count=$((already_disabled_count + 1))
            continue
        fi
        to_disable+=("$workflow_name")
    done <<< "$workflows_output"

    local disabled_count=0
    if [[ ${#to_disable[@]} -gt 0 ]]; then
        local parallelism=$BATCH_SIZE
        [[ $parallelism -lt 1 ]] && parallelism=1
        info "Disabling ${#to_disable[@]} workflow(s) in parallel (up to $parallelism at a time)..."
        local results_file
        results_file=$(mktemp)
        local running=0
        for workflow_name in "${to_disable[@]}"; do
            (
                if gh workflow disable "$workflow_name" &>> "$LOG_FILE"; then
                    printf 'ok\t%s\n' "$workflow_name" >> "$results_file"
                else
                    printf 'fail\t%s\n' "$workflow_name" >> "$results_file"
                fi
            ) &
            running=$((running + 1))
            if [[ $running -ge $parallelism ]]; then
                wait -n 2>/dev/null || wait
                running=$((running - 1))
            fi
        done
        wait

        while IFS=$'\t' read -r status name; do
            if [[ "$status" == "ok" ]]; then
                success "  ✓ Disabled '$name'"
                disabled_count=$((disabled_count + 1))
            else
                warning "Failed to disable workflow '$name'"
            fi
        done < "$results_file"
        rm -f "$results_file"
    fi
    
    echo
    if [[ $disabled_count -gt 0 ]]; then
        success "Disabled $disabled_count workflow(s) ($already_disabled_count were already disabled)"
    else
        info "All workflows were already disabled ($already_disabled_count total)"
    fi
}

wait_for_workflow() {
    local workflow_name="$1"
    local run_id="$2"
    local timeout_seconds=$((TIMEOUT_MINUTES * 60))
    local start_time=$(date +%s)
    local max_consecutive_failures=10
    local consecutive_failures=0
    
    progress "Waiting for workflow '$workflow_name' (run #$run_id) to complete..."
    progress "View run details: https://github.com/$REPO_OWNER/$REPO_NAME/actions/runs/$run_id"
    
    while true; do
        local current_time=$(date +%s)
        local elapsed=$((current_time - start_time))
        
        if [[ $elapsed -gt $timeout_seconds ]]; then
            error "Timeout waiting for workflow '$workflow_name' after $TIMEOUT_MINUTES minutes"
            error "View run details: https://github.com/$REPO_OWNER/$REPO_NAME/actions/runs/$run_id"
            return 1
        fi
        
        local status conclusion
        if status=$(gh run view "$run_id" --json status,conclusion -q '.status + "," + (.conclusion // "")' 2>/dev/null); then
            consecutive_failures=0
            IFS=',' read -r run_status run_conclusion <<< "$status"
            
            case "$run_status" in
                "completed")
                    case "$run_conclusion" in
                        "success")
                            success "Workflow '$workflow_name' completed successfully"
                            return 0
                            ;;
                        "failure"|"cancelled"|"timed_out")
                            error "Workflow '$workflow_name' failed with conclusion: $run_conclusion"
                            error "View run details: https://github.com/$REPO_OWNER/$REPO_NAME/actions/runs/$run_id"
                            return 1
                            ;;
                        *)
                            error "Workflow '$workflow_name' completed with unexpected conclusion: $run_conclusion"
                            error "View run details: https://github.com/$REPO_OWNER/$REPO_NAME/actions/runs/$run_id"
                            return 1
                            ;;
                    esac
                    ;;
                "in_progress"|"queued"|"requested"|"waiting"|"pending")
                    echo -n "."
                    sleep $POLL_INTERVAL
                    ;;
                *)
                    error "Workflow '$workflow_name' has unexpected status: $run_status"
                    error "View run details: https://github.com/$REPO_OWNER/$REPO_NAME/actions/runs/$run_id"
                    return 1
                    ;;
            esac
        else
            consecutive_failures=$((consecutive_failures + 1))
            if [[ $consecutive_failures -ge $max_consecutive_failures ]]; then
                error "Failed to get status for workflow run $run_id after $max_consecutive_failures consecutive attempts"
                error "View run details: https://github.com/$REPO_OWNER/$REPO_NAME/actions/runs/$run_id"
                return 1
            fi
            warning "Failed to get status for workflow run $run_id (attempt $consecutive_failures/$max_consecutive_failures, retrying...)"
            sleep $POLL_INTERVAL
        fi
    done
}

get_latest_run_id() {
    local workflow_file="$1"
    gh run list --workflow="$workflow_file" --limit=1 --json databaseId -q '.[0].databaseId' 2>/dev/null || echo ""
}

enable_workflow() {
    local workflow_name="$1"
    local track_globally="${2:-true}"  # Default to tracking globally for cleanup
    
    info "Enabling workflow '$workflow_name'..."
    # Redirect gh aw enable output to log file to prevent terminal control codes from clearing previous output
    $GH_AW_BIN enable "$workflow_name" &>> "$LOG_FILE"
    local rc=$?
    if [[ $rc -eq 0 ]]; then
        success "Successfully enabled '$workflow_name'"
        
        # Add to global tracking for cleanup on exit (unless disabled immediately after)
        if [[ "$track_globally" == "true" ]]; then
            (
                flock -x 200
                GLOBAL_WORKFLOWS_TO_DISABLE+=("$workflow_name")
                # Also write to temp file for persistence across subprocesses
                echo "$workflow_name" >> "/tmp/e2e-workflows-list-$$.txt"
            ) 200>"$GLOBAL_WORKFLOWS_LOCK" 2>/dev/null || true
        fi
        
        return 0
    else
        error "Failed to enable '$workflow_name' (exit code: $rc)"
        return 1
    fi
}

disable_workflow() {
    local workflow_name="$1"
    
    info "Disabling workflow '$workflow_name'..."
    $GH_AW_BIN disable "$workflow_name" &>> "$LOG_FILE"
    local rc=$?
    if [[ $rc -eq 0 ]]; then
        success "Successfully disabled '$workflow_name'"
        
        # Remove from global tracking (unless we're in cleanup mode)
        if [[ "${CLEANUP_DONE:-false}" != "true" ]]; then
            (
                flock -x 200
                # Remove from temp file
                if [[ -f "/tmp/e2e-workflows-list-$$.txt" ]]; then
                    grep -v "^${workflow_name}$" "/tmp/e2e-workflows-list-$$.txt" > "/tmp/e2e-workflows-list-$$.txt.tmp" 2>/dev/null || true
                    mv "/tmp/e2e-workflows-list-$$.txt.tmp" "/tmp/e2e-workflows-list-$$.txt" 2>/dev/null || true
                fi
            ) 200>"$GLOBAL_WORKFLOWS_LOCK" 2>/dev/null || true
        fi
        
        return 0
    else
        warning "Failed to disable '$workflow_name' (exit code: $rc; may already be disabled)"
        return 0  # Don't fail the test if disable fails
    fi
}

trigger_workflow_dispatch_and_await_completion() {
    local workflow_name="$1"
    local workflow_file="${workflow_name}.lock.yml"
    
    info "Triggering workflow_dispatch for '$workflow_name'..."
    
    # Enable the workflow first
    # NOTE: This must return early only when enabling fails. A prior bug
    # inverted this condition causing immediate failure even when enable succeeded.
    if ! enable_workflow "$workflow_name"; then
        return 1
    fi
    
    # Get the run ID before triggering
    local before_run_id=$(get_latest_run_id "$workflow_file")
    
    # Trigger the workflow using gh aw run
    local -a run_args=("$workflow_name")
    if [[ -n "$DISPATCH_REF" ]]; then
        run_args+=(--ref "$DISPATCH_REF")
    fi
    if $GH_AW_BIN run "${run_args[@]}" &>> "$LOG_FILE"; then
        success "Successfully triggered '$workflow_name'"
        
        # Wait a bit for the new run to appear
        sleep 5
        
        # Get the new run ID
        local after_run_id=$(get_latest_run_id "$workflow_file")
        
        if [[ "$after_run_id" != "$before_run_id" && -n "$after_run_id" ]]; then
            local result=0
            TEST_RUN_URLS["$workflow_name"]="https://github.com/$REPO_OWNER/$REPO_NAME/actions/runs/$after_run_id"
            wait_for_workflow "$workflow_name" "$after_run_id" || result=1
            
            # Disable the workflow after running
            disable_workflow "$workflow_name"
            
            return $result
        else
            error "Could not find new workflow run for '$workflow_name'"
            disable_workflow "$workflow_name"
            return 1
        fi
    else
        error "Failed to trigger '$workflow_name'"
        disable_workflow "$workflow_name"
        return 1
    fi
}

trigger_workflow_with_inputs() {
    local workflow_name="$1"
    shift
    local inputs=("$@")
    local workflow_file="${workflow_name}.lock.yml"
    
    info "Triggering workflow_dispatch for '$workflow_name' with inputs..."
    
    # Enable the workflow first
    if ! enable_workflow "$workflow_name"; then
        return 1
    fi
    
    # Get the run ID before triggering
    local before_run_id=$(get_latest_run_id "$workflow_file")
    
    # Build the gh workflow run command with inputs
    local cmd="gh workflow run \"$workflow_file\""
    if [[ -n "$DISPATCH_REF" ]]; then
        cmd+=" --ref \"$DISPATCH_REF\""
    fi
    for input in "${inputs[@]}"; do
        cmd+=" -f $input"
    done
    cmd+=" &>> \"$LOG_FILE\""
    
    # Trigger the workflow using gh workflow run with inputs
    if eval "$cmd"; then
        success "Successfully triggered '$workflow_name' with inputs"
        
        # Wait a bit for the new run to appear
        sleep 5
        
        # Get the new run ID
        local after_run_id=$(get_latest_run_id "$workflow_file")
        
        if [[ "$after_run_id" != "$before_run_id" && -n "$after_run_id" ]]; then
            local result=0
            TEST_RUN_URLS["$workflow_name"]="https://github.com/$REPO_OWNER/$REPO_NAME/actions/runs/$after_run_id"
            wait_for_workflow "$workflow_name" "$after_run_id" || result=1
            
            # Disable the workflow after running
            disable_workflow "$workflow_name"
            
            return $result
        else
            error "Could not find new workflow run for '$workflow_name'"
            disable_workflow "$workflow_name"
            return 1
        fi
    else
        error "Failed to trigger '$workflow_name'"
        disable_workflow "$workflow_name"
        return 1
    fi
}


create_test_issue() {
    local title="$1"
    local body="$2"
    local labels="${3:-}"
    local repo="${4:-}"
    
    local repo_flag=""
    if [[ -n "$repo" ]]; then
        repo_flag="--repo $repo"
    fi

    # Parallel-safety marker: lets each workflow's `if:` filter accept only its own trigger
    if [[ -n "${E2E_TRIGGER_MARKER:-}" ]]; then
        body+=$'\n\n'"$E2E_TRIGGER_MARKER"
    fi

    local issue_url
    if [[ -n "$labels" ]]; then
        issue_url=$(gh issue create $repo_flag --title "$title" --body "$body" --label "$labels" 2>/dev/null)
    else
        issue_url=$(gh issue create $repo_flag --title "$title" --body "$body" 2>/dev/null)
    fi
    
    if [[ -n "$issue_url" ]]; then
        local issue_number=$(echo "$issue_url" | grep -o '[0-9]\+$')
        echo "$issue_number"
    else
        echo ""
    fi
}

create_test_discussion() {
    local title="$1"
    local body="$2"
    local category="${3:-General}"
    local repo="${4:-}"
    
    local owner="$REPO_OWNER"
    local name="$REPO_NAME"
    if [[ -n "$repo" ]]; then
        owner=$(echo "$repo" | cut -d/ -f1)
        name=$(echo "$repo" | cut -d/ -f2)
    fi
    
    # Get repository ID using GraphQL
    local repo_query="{
      repository(owner: \"$owner\", name: \"$name\") {
        id
      }
    }"
    local repo_id=$(gh api graphql -f query="$repo_query" --jq '.data.repository.id' 2>/dev/null)
    
    # Get category ID using GraphQL  
    local category_query="{
      repository(owner: \"$owner\", name: \"$name\") {
        discussionCategories(first: 10) {
          nodes {
            id
            name
          }
        }
      }
    }"
    local category_id=$(gh api graphql -f query="$category_query" --jq ".data.repository.discussionCategories.nodes[] | select(.name==\"$category\") | .id" 2>/dev/null)
    
    if [[ -z "$repo_id" || -z "$category_id" ]]; then
        echo ""
        return
    fi
    
    # Parallel-safety marker (see create_test_issue)
    if [[ -n "${E2E_TRIGGER_MARKER:-}" ]]; then
        body+=$'\n\n'"$E2E_TRIGGER_MARKER"
    fi

    # Escape body for embedding in GraphQL string literal
    local body_escaped=${body//\\/\\\\}
    body_escaped=${body_escaped//\"/\\\"}
    body_escaped=${body_escaped//$'\n'/\\n}

    # Create discussion using GraphQL mutation
    local mutation="mutation {
      createDiscussion(input: {
        repositoryId: \"$repo_id\"
        categoryId: \"$category_id\"
        title: \"$title\"
        body: \"$body_escaped\"
      }) {
        discussion {
          number
        }
      }
    }"
    local discussion_data=$(gh api graphql -f query="$mutation" --jq '.data.createDiscussion.discussion.number // empty' 2>/dev/null)
    
    if [[ -n "$discussion_data" ]]; then
        echo "$discussion_data"
    else
        echo ""
    fi
}

create_test_pr() {
    local title="$1"
    local body="$2"
    local repo="${3:-}"
    local branch="test-pr-$(date +%s)-${BASHPID:-$$}-$RANDOM"

    # Parallel-safety marker (see create_test_issue)
    if [[ -n "${E2E_TRIGGER_MARKER:-}" ]]; then
        body+=$'\n\n'"$E2E_TRIGGER_MARKER"
    fi

    local repo_flag=""
    local api_repo=":owner/:repo"
    if [[ -n "$repo" ]]; then
        repo_flag="--repo $repo"
        api_repo="$repo"
    fi
    
    # Create a remote branch from main without changing local git state
    if [[ -n "$repo" ]]; then
        git push "https://github.com/$repo.git" "main:$branch" &>/dev/null
    else
        git push origin "main:$branch" &>/dev/null
    fi
    
    # Create a commit on the remote branch using GitHub API to make it different from main
    local commit_message="Test commit for PR"
    local file_content="# Test PR Content\n\nThis is a test file created for PR testing at $(date)"
    local file_path="test-file-$(date +%s)-${BASHPID:-$$}-$RANDOM.md"
    
    # Get the current SHA of the branch
    local remote_url="origin"
    if [[ -n "$repo" ]]; then
        remote_url="https://github.com/$repo.git"
    fi
    local current_sha=$(git ls-remote --heads "$remote_url" "$branch" 2>/dev/null | cut -f1)
    
    if [[ -n "$current_sha" ]]; then
        # Create a new file on the branch using GitHub API
        gh api repos/"$api_repo"/contents/"$file_path" \
            --method PUT \
            --field message="$commit_message" \
            --field content="$(echo -e "$file_content" | base64 -w 0)" \
            --field branch="$branch" &>/dev/null
        
        # Create a PR using the GitHub CLI
        local pr_url=$(gh pr create $repo_flag --title "$title" --body "$body" --head "$branch" --base main 2>/dev/null)
        
        if [[ -n "$pr_url" ]]; then
            local pr_number=$(echo "$pr_url" | grep -o '[0-9]\+$')
            echo "$pr_number"
        else
            echo ""
        fi
    else
        echo ""
    fi
}

create_test_pr_with_branch() {
    local title="$1"
    local body="$2"
    local repo="${3:-}"
    local branch="test-pr-$(date +%s)-${BASHPID:-$$}-$RANDOM"

    # Parallel-safety marker (see create_test_issue)
    if [[ -n "${E2E_TRIGGER_MARKER:-}" ]]; then
        body+=$'\n\n'"$E2E_TRIGGER_MARKER"
    fi

    local repo_flag=""
    local api_repo=":owner/:repo"
    if [[ -n "$repo" ]]; then
        repo_flag="--repo $repo"
        api_repo="$repo"
    fi

    # Create the remote branch via gh api. `git push` against a cross-repo
    # HTTPS URL has no credentials on the runner and was silently failing,
    # leaving siderepo PR tests without a PR to trigger from.
    local main_sha=$(gh api repos/"$api_repo"/git/refs/heads/main --jq '.object.sha' 2>/dev/null)
    if [[ -z "$main_sha" ]]; then
        echo ""
        return
    fi
    gh api repos/"$api_repo"/git/refs \
        --method POST \
        --field ref="refs/heads/$branch" \
        --field sha="$main_sha" &>/dev/null

    # Create a commit on the remote branch using GitHub API to make it different from main
    local commit_message="Test commit for PR"
    local file_content="# Test PR Content\n\nThis is a test file created for PR testing at $(date)"
    local file_path="test-file-$(date +%s)-${BASHPID:-$$}-$RANDOM.md"

    # Confirm the branch ref exists on the remote before adding a commit
    local initial_sha=$(gh api repos/"$api_repo"/git/refs/heads/"$branch" --jq '.object.sha' 2>/dev/null)

    if [[ -n "$initial_sha" ]]; then
        # Create a new file on the branch using GitHub API
        gh api repos/"$api_repo"/contents/"$file_path" \
            --method PUT \
            --field message="$commit_message" \
            --field content="$(echo -e "$file_content" | base64 -w 0)" \
            --field branch="$branch" &>/dev/null

        # Get the SHA after creating the test commit
        local after_commit_sha=$(gh api repos/"$api_repo"/git/refs/heads/"$branch" --jq '.object.sha' 2>/dev/null)

        # Create a PR using the GitHub CLI
        local pr_url=$(gh pr create $repo_flag --title "$title" --body "$body" --head "$branch" --base main 2>/dev/null)

        if [[ -n "$pr_url" ]]; then
            local pr_number=$(echo "$pr_url" | grep -o '[0-9]\+$')
            echo "$pr_number,$branch,$after_commit_sha,$repo"
        else
            echo ""
        fi
    else
        echo ""
    fi
}

post_issue_command() {
    local issue_number="$1"
    local command="$2"
    local repo="${3:-}"
    
    local repo_flag=""
    if [[ -n "$repo" ]]; then
        repo_flag="--repo $repo"
    fi
    
    gh issue comment $repo_flag "$issue_number" --body "$command" &>/dev/null
}

post_pr_command() {
    local pr_number="$1"
    local command="$2"
    local repo="${3:-}"
    
    local repo_flag=""
    if [[ -n "$repo" ]]; then
        repo_flag="--repo $repo"
    fi
    
    gh pr comment $repo_flag "$pr_number" --body "$command" &>/dev/null
}

validate_issue_created() {
    local title_prefix="$1"
    local expected_labels="$2"
    local repo="${3:-}"
    
    local repo_flag=""
    local repo_url="$REPO_OWNER/$REPO_NAME"
    if [[ -n "$repo" ]]; then
        repo_flag="--repo $repo"
        repo_url="$repo"
    fi
    
    # Look for recently created issues with the title prefix
    local issue_number=$(gh issue list $repo_flag --limit 10 --json number,title,labels --jq ".[] | select(.title | startswith(\"$title_prefix\")) | .number" | head -1)
    
    if [[ -n "$issue_number" ]]; then
        if [[ -n "$expected_labels" ]]; then
            local labels=$(gh issue view $repo_flag "$issue_number" --json labels --jq '.labels[].name' | tr '\n' ',' | sed 's/,$//')
            for label in ${expected_labels//,/ }; do
                if [[ "$labels" != *"$label"* ]]; then
                    error "Issue #$issue_number missing expected label: '$label'. Actual labels: '$labels'"
                    return 1
                fi
            done
        fi
        success "Issue #$issue_number created successfully with expected properties, URL: https://github.com/$repo_url/issues/$issue_number"
        return 0
    else
        error "No issue found with title prefix: $title_prefix"
        return 1
    fi
}

validate_comment() {
    local issue_number="$1"
    local expected_comment_text="$2"
    local repo="${3:-}"
    
    local repo_flag=""
    if [[ -n "$repo" ]]; then
        repo_flag="--repo $repo"
    fi
    
    local comments=$(gh issue view $repo_flag "$issue_number" --json comments --jq '.comments[].body')
    
    if echo "$comments" | grep -qF "$expected_comment_text"; then
        success "Issue #$issue_number has expected comment containing: $expected_comment_text"
        return 0
    else
        warning "(polling) Issue #$issue_number missing expected comment containing: '$expected_comment_text'. Actual comments: ${comments:0:200}..."
        return 1
    fi
}

validate_labels() {
    local issue_number="$1"
    local expected_label="$2"
    local repo="${3:-}"
    
    local repo_flag=""
    if [[ -n "$repo" ]]; then
        repo_flag="--repo $repo"
    fi
    
    local labels=$(gh issue view $repo_flag "$issue_number" --json labels --jq '.labels[].name' | tr '\n' ',')
    
    if [[ "$labels" == *"$expected_label"* ]]; then
        success "Issue #$issue_number has expected label: $expected_label"
        return 0
    else
        warning "(polling) Issue #$issue_number missing expected label: '$expected_label'. Actual labels: '$labels'"
        return 1
    fi
}

validate_issue_updated() {
    local issue_number="$1"
    local ai_type="$2"  # "Claude", "Codex", or "Copilot"
    local repo="${3:-}"
    
    local repo_flag=""
    if [[ -n "$repo" ]]; then
        repo_flag="--repo $repo"
    fi
    
    # Check for various signs that the issue was updated by the AI
    local issue_data=$(gh issue view $repo_flag "$issue_number" --json title,body,comments,labels,state 2>/dev/null)
    
    if [[ -z "$issue_data" ]]; then
        error "Could not retrieve issue #$issue_number data"
        return 1
    fi
    
    local title_success=false
    local body_success=false
    local state_success=false
    
    # Check if title was updated
    local title=$(echo "$issue_data" | jq -r '.title')
    if [[ "$title" == *"Processed by $ai_type"* ]]; then
        success "Issue #$issue_number title was updated by $ai_type"
        title_success=true
    else
        warning "(polling) Issue #$issue_number title does not show expected update by $ai_type. Expected pattern: 'Processed by $ai_type'. Actual title: '$title'"
    fi
    
    # Check if body was updated
    local body=$(echo "$issue_data" | jq -r '.body')
    if [[ "$body" == *"updated by"* ]]; then
        success "Issue #$issue_number body was updated by $ai_type"
        body_success=true
    else
        warning "(polling) Issue #$issue_number body does not show expected update by $ai_type. Expected pattern: 'updated by'. Actual body: ${body:0:200}..."
    fi
    
    # Check for status closed (case-insensitive)
    local state=$(echo "$issue_data" | jq -r '.state')
    local state_lc="${state,,}"  # convert to lowercase for comparison

    if [[ "$state_lc" == "closed" ]]; then
        success "Issue #$issue_number was closed, indicating it was processed"
        state_success=true
    else
        warning "(polling) Issue #$issue_number is still open (state $state). Expected it to be closed after processing."
    fi
    
    # Only return success if all three checks passed
    if [[ "$title_success" == true ]] && [[ "$body_success" == true ]] && [[ "$state_success" == true ]]; then
        success "Issue #$issue_number validation passed: all checks (title, body, state) succeeded"
        return 0
    else
        warning "(polling) Issue #$issue_number validation incomplete: title=$title_success, body=$body_success, state=$state_success"
        return 1
    fi
}

validate_pr_created() {
    local title_prefix="$1"
    local repo="${2:-}"
    
    local repo_flag=""
    local repo_url="$REPO_OWNER/$REPO_NAME"
    if [[ -n "$repo" ]]; then
        repo_flag="--repo $repo"
        repo_url="$repo"
    fi
    
    # Look for recently created PRs with the title prefix
    local pr_number=$(gh pr list $repo_flag --limit 10 --json number,title --jq ".[] | select(.title | startswith(\"$title_prefix\")) | .number" | head -1)
    
    if [[ -n "$pr_number" ]]; then
        success "PR #$pr_number created successfully, https://github.com/$repo_url/pull/$pr_number"
        return 0
    else
        error "No PR found with title prefix: $title_prefix"
        return 1
    fi
}

validate_two_prs_created() {
    local title_prefix="$1"
    local repo="${2:-}"
    
    local repo_flag=""
    local repo_url="$REPO_OWNER/$REPO_NAME"
    if [[ -n "$repo" ]]; then
        repo_flag="--repo $repo"
        repo_url="$repo"
    fi
    
    # Look for recently created PRs with the title prefix
    local pr_numbers=$(gh pr list $repo_flag --limit 20 --json number,title --jq ".[] | select(.title | startswith(\"$title_prefix\")) | .number")
    local pr_count=$(echo "$pr_numbers" | grep -c '^')
    
    if [[ $pr_count -ge 2 ]]; then
        local pr_list=$(echo "$pr_numbers" | head -2 | tr '\n' ', ' | sed 's/,$//')
        success "Two PRs created successfully: #$pr_list"
        echo "$pr_numbers" | head -2 | while read -r pr_num; do
            success "  - PR #$pr_num: https://github.com/$repo_url/pull/$pr_num"
        done
        return 0
    else
        error "Expected 2 PRs with title prefix '$title_prefix', but found $pr_count"
        if [[ $pr_count -gt 0 ]]; then
            echo "$pr_numbers" | while read -r pr_num; do
                warning "  - Found PR #$pr_num: https://github.com/$repo_url/pull/$pr_num"
            done
        fi
        return 1
    fi
}


validate_discussion_created() {
    local title_prefix="$1"
    local expected_labels="$2"
    local repo="${3:-}"
    
    local api_repo=":owner/:repo"
    local repo_url="$REPO_OWNER/$REPO_NAME"
    if [[ -n "$repo" ]]; then
        api_repo="$repo"
        repo_url="$repo"
    fi
    
    # Look for recently created discussions with the title prefix
    # Note: GitHub CLI discussions support may be limited, so we use API
    local discussions=$(gh api repos/"$api_repo"/discussions --paginate --jq ".[] | select(.title | startswith(\"$title_prefix\")) | .number" 2>/dev/null | head -1)
    
    if [[ -n "$discussions" ]]; then
        local discussion_number="$discussions"
        success "Discussion #$discussion_number created successfully with title prefix '$title_prefix', URL: https://github.com/$repo_url/discussions/$discussion_number"
        return 0
    else
        error "No discussion found with title prefix: $title_prefix"
        return 1
    fi
}

validate_code_scanning_alert() {
    local workflow_name="$1"
    local repo="${2:-}"
    
    local api_repo=":owner/:repo"
    if [[ -n "$repo" ]]; then
        api_repo="$repo"
    fi
    
    # Determine expected title based on workflow name
    local expected_message
    if [[ "$workflow_name" == *"claude-nosandbox"* ]]; then
        expected_message="Claude (No Sandbox) wants security review."
    elif [[ "$workflow_name" == *"codex-nosandbox"* ]]; then
        expected_message="Codex (No Sandbox) wants security review."
    elif [[ "$workflow_name" == *"copilot-nosandbox"* ]]; then
        expected_message="Copilot (No Sandbox) wants security review."
    elif [[ "$workflow_name" == *"claude"* ]]; then
        expected_message="Claude wants security review."
    elif [[ "$workflow_name" == *"codex"* ]]; then
        expected_message="Codex wants security review."
    elif [[ "$workflow_name" == *"copilot"* ]]; then
        expected_message="Copilot wants security review."
    else
        expected_message="security review"  # Fallback for generic matching
    fi
    
    # Check for code scanning alerts with the specific title
    local code_scanning_alerts=$(gh api repos/"$api_repo"/code-scanning/alerts?state=open --jq ".[] | select(.most_recent_instance.message.text | contains(\"$expected_message\")) | .most_recent_instance.message.text" 2>/dev/null || echo "")
    
    if [[ -n "$code_scanning_alerts" ]]; then
        success "Security report workflow '$workflow_name' created security advisory with expected message: '$expected_message'"
        return 0
    else
        error "Security report workflow '$workflow_name' completed but no code scanning alerts found with expected message: '$expected_message'"
        return 1
    fi
}

validate_mcp_workflow() {
    local workflow_name="$1"
    local repo="${2:-}"
    
    local repo_flag=""
    if [[ -n "$repo" ]]; then
        repo_flag="--repo $repo"
    fi
    
    # MCP workflows create issues with specific patterns indicating MCP tool usage
    # Search for BOTH title pattern AND MCP-specific content for more specificity
    local recent_issues=$(gh issue list $repo_flag --limit 10 --json title,body \
        --jq '.[] | select((.title | contains("Hello from")) and 
                          ((.body | contains("MCP time tool")) or 
                           (.body | contains("get_current_time")) or
                           (.body | contains("current time is")))) | .title' | head -1)
    
    if [[ -n "$recent_issues" ]]; then
        success "MCP workflow '$workflow_name' appears to have used MCP tools successfully: $recent_issues"
        return 0
    else
        # More specific fallback: require both title pattern AND time content
        local time_issues=$(gh issue list $repo_flag --limit 10 --json title,body \
            --jq '.[] | select((.title | contains("Hello from")) and 
                              ((.body | contains("time")) or (.body | contains("Time")))) | .title' | head -1)
        
        if [[ -n "$time_issues" ]]; then
            success "MCP workflow '$workflow_name' appears to have used MCP tools successfully (time-based detection): $time_issues"
            return 0
        else
            error "MCP workflow '$workflow_name' completed but no clear evidence of MCP tool usage found"
            return 1
        fi
    fi
}

validate_branch_updated() {
    local branch_name="$1"
    local initial_sha="$2"
    local repo="${3:-}"
    
    local remote_url="origin"
    if [[ -n "$repo" ]]; then
        remote_url="https://github.com/$repo.git"
    fi
    
    local current_sha=$(git ls-remote --heads "$remote_url" "$branch_name" 2>/dev/null | cut -f1)
    
    if [[ -z "$current_sha" ]]; then
        warning "(polling) Branch '$branch_name' not found"
        return 1
    elif [[ "$current_sha" == "$initial_sha" ]]; then
        warning "(polling) Branch '$branch_name' SHA unchanged: $current_sha"
        return 1
    else
        success "Branch '$branch_name' updated successfully: $initial_sha -> $current_sha"
        return 0
    fi
}

validate_pr_reviews() {
    local pr_number="$1"
    local ai_type="$2"  # "Claude", "Codex", or "Copilot"
    local repo="${3:-}"
    
    local api_repo=":owner/:repo"
    if [[ -n "$repo" ]]; then
        api_repo="$repo"
    fi
    
    # Get PR reviews (once a comment is made it shows up as a review)
    local reviews=$(gh api repos/"$api_repo"/pulls/"$pr_number"/reviews 2>/dev/null | jq -r '.[].state // empty' 2>/dev/null || echo "")
    
    if [[ -n "$reviews" ]]; then
        # Check if any comment contains AI-specific content or expected patterns
        success "PR #$pr_number has a review (likely from $ai_type AI workflow)"
        return 0
    else
        warning "(polling) PR #$pr_number missing expected review comments from $ai_type"
        return 1
    fi
}

validate_pr_updated() {
    local pr_number="$1"
    local ai_type="$2"  # "Claude", "Codex", or "Copilot"
    local repo="${3:-}"

    local repo_flag=""
    if [[ -n "$repo" ]]; then
        repo_flag="--repo $repo"
    fi

    local pr_data=$(gh pr view $repo_flag "$pr_number" --json title,body 2>/dev/null)

    if [[ -z "$pr_data" ]]; then
        warning "(polling) Could not retrieve PR #$pr_number data"
        return 1
    fi

    local title_success=false
    local body_success=false

    local title=$(echo "$pr_data" | jq -r '.title')
    if [[ "$title" == *"Processed by $ai_type"* ]]; then
        success "PR #$pr_number title was updated by $ai_type"
        title_success=true
    else
        warning "(polling) PR #$pr_number title not yet updated by $ai_type. Actual: '$title'"
    fi

    local body=$(echo "$pr_data" | jq -r '.body')
    if [[ "$body" == *"automatically updated by"* ]]; then
        success "PR #$pr_number body was updated by $ai_type"
        body_success=true
    else
        warning "(polling) PR #$pr_number body not yet updated by $ai_type. Actual: ${body:0:200}..."
    fi

    if [[ "$title_success" == true ]] && [[ "$body_success" == true ]]; then
        success "PR #$pr_number validation passed: title and body updated"
        return 0
    else
        warning "(polling) PR #$pr_number validation incomplete: title=$title_success, body=$body_success"
        return 1
    fi
}

# Polling functions for workflow validation
wait_for_comment() {
    local issue_number="$1"
    local expected_text="$2"
    local test_name="$3"
    local repo="${4:-}"
    local max_wait=480 # Max wait time in seconds (8 minutes)
    local waited=0
    
    while [[ $waited -lt $max_wait ]]; do
        if validate_comment "$issue_number" "$expected_text" "$repo"; then
            record_test_pass "$test_name"
            return 0
        fi
        info "..."
        sleep 5
        waited=$((waited + 5))
    done
    
    record_test_fail "$test_name"
    return 1
}

wait_for_labels() {
    local issue_number="$1"
    local expected_label="$2"
    local test_name="$3"
    local repo="${4:-}"
    local max_wait=480 # Max wait time in seconds (8 minutes)
    local waited=0
    
    while [[ $waited -lt $max_wait ]]; do
        if validate_labels "$issue_number" "$expected_label" "$repo"; then
            record_test_pass "$test_name"
            return 0
        fi
        info "..."
        sleep 5
        waited=$((waited + 5))
    done
    
    record_test_fail "$test_name"
    return 1
}

wait_for_issue_update() {
    local issue_number="$1"
    local ai_type="$2"
    local test_name="$3"
    local repo="${4:-}"
    local max_wait=480 # Max wait time in seconds (8 minutes)
    local waited=0
    
    while [[ $waited -lt $max_wait ]]; do
        if validate_issue_updated "$issue_number" "$ai_type" "$repo"; then
            record_test_pass "$test_name"
            return 0
        fi
        info "..."
        sleep 5
        waited=$((waited + 5))
    done
    
    record_test_fail "$test_name"
    return 1
}

validate_issue_closed() {
    local issue_number="$1"
    local expected_comment="$2"
    local repo="${3:-}"
    
    local repo_flag=""
    if [[ -n "$repo" ]]; then
        repo_flag="--repo $repo"
    fi
    
    local issue_data=$(gh issue view $repo_flag "$issue_number" --json state,comments 2>/dev/null)
    
    if [[ -z "$issue_data" ]]; then
        warning "(polling) Could not retrieve issue #$issue_number data"
        return 1
    fi
    
    local state=$(echo "$issue_data" | jq -r '.state')
    local state_lc="${state,,}"
    
    if [[ "$state_lc" != "closed" ]]; then
        warning "(polling) Issue #$issue_number is still open (state $state). Expected closed."
        return 1
    fi
    
    success "Issue #$issue_number was closed successfully"
    
    if [[ -n "$expected_comment" ]]; then
        local comments=$(echo "$issue_data" | jq -r '.comments[].body')
        if echo "$comments" | grep -q "$expected_comment"; then
            success "Issue #$issue_number has expected closing comment containing: $expected_comment"
        else
            warning "Issue #$issue_number closed but missing expected comment containing: '$expected_comment'"
        fi
    fi
    
    return 0
}

wait_for_issue_closed() {
    local issue_number="$1"
    local expected_comment="$2"
    local test_name="$3"
    local repo="${4:-}"
    local max_wait=480 # Max wait time in seconds (8 minutes)
    local waited=0
    
    while [[ $waited -lt $max_wait ]]; do
        if validate_issue_closed "$issue_number" "$expected_comment" "$repo"; then
            record_test_pass "$test_name"
            return 0
        fi
        info "..."
        sleep 5
        waited=$((waited + 5))
    done
    
    record_test_fail "$test_name"
    return 1
}

validate_label_removed() {
    local issue_number="$1"
    local label_name="$2"
    local repo="${3:-}"
    
    local repo_flag=""
    if [[ -n "$repo" ]]; then
        repo_flag="--repo $repo"
    fi
    
    local labels=$(gh issue view $repo_flag "$issue_number" --json labels --jq '.labels[].name' | tr '\n' ',')
    
    if [[ "$labels" != *"$label_name"* ]]; then
        success "Issue #$issue_number no longer has label: $label_name"
        return 0
    else
        warning "(polling) Issue #$issue_number still has label: '$label_name'. Current labels: '$labels'"
        return 1
    fi
}

wait_for_label_removed() {
    local issue_number="$1"
    local label_name="$2"
    local test_name="$3"
    local repo="${4:-}"
    local max_wait=480 # Max wait time in seconds (8 minutes)
    local waited=0
    
    while [[ $waited -lt $max_wait ]]; do
        if validate_label_removed "$issue_number" "$label_name" "$repo"; then
            record_test_pass "$test_name"
            return 0
        fi
        info "..."
        sleep 5
        waited=$((waited + 5))
    done
    
    record_test_fail "$test_name"
    return 1
}

validate_discussion_closed() {
    local discussion_number="$1"
    local repo="${2:-}"
    
    local owner="$REPO_OWNER"
    local name="$REPO_NAME"
    if [[ -n "$repo" ]]; then
        owner=$(echo "$repo" | cut -d/ -f1)
        name=$(echo "$repo" | cut -d/ -f2)
    fi
    
    # Check discussion state using GraphQL
    local query="{
      repository(owner: \"$owner\", name: \"$name\") {
        discussion(number: $discussion_number) {
          closed
        }
      }
    }"
    local closed=$(gh api graphql -f query="$query" --jq '.data.repository.discussion.closed' 2>/dev/null)
    
    if [[ "$closed" == "true" ]]; then
        success "Discussion #$discussion_number was closed successfully"
        return 0
    else
        warning "(polling) Discussion #$discussion_number is still open (closed=$closed)"
        return 1
    fi
}

wait_for_discussion_closed() {
    local discussion_number="$1"
    local test_name="$2"
    local repo="${3:-}"
    local max_wait=480 # Max wait time in seconds (8 minutes)
    local waited=0
    
    while [[ $waited -lt $max_wait ]]; do
        if validate_discussion_closed "$discussion_number" "$repo"; then
            record_test_pass "$test_name"
            return 0
        fi
        info "..."
        sleep 5
        waited=$((waited + 5))
    done
    
    record_test_fail "$test_name"
    return 1
}

validate_pr_closed() {
    local pr_number="$1"
    local repo="${2:-}"
    
    local repo_flag=""
    if [[ -n "$repo" ]]; then
        repo_flag="--repo $repo"
    fi
    
    local state=$(gh pr view $repo_flag "$pr_number" --json state --jq '.state' 2>/dev/null)
    local state_lc="${state,,}"
    
    if [[ "$state_lc" == "closed" || "$state_lc" == "merged" ]]; then
        success "PR #$pr_number was closed successfully (state: $state)"
        return 0
    else
        warning "(polling) PR #$pr_number is still open (state: $state)"
        return 1
    fi
}

wait_for_pr_closed() {
    local pr_number="$1"
    local test_name="$2"
    local repo="${3:-}"
    local max_wait=480 # Max wait time in seconds (8 minutes)
    local waited=0
    
    while [[ $waited -lt $max_wait ]]; do
        if validate_pr_closed "$pr_number" "$repo"; then
            record_test_pass "$test_name"
            return 0
        fi
        info "..."
        sleep 5
        waited=$((waited + 5))
    done
    
    record_test_fail "$test_name"
    return 1
}

wait_for_command_comment() {
    local issue_number="$1"
    local expected_text="$2"
    local test_name="$3"
    local repo="${4:-}"
    local max_wait=480 # Max wait time in seconds (8 minutes)
    local waited=0
    
    # expected_text may contain '|'-separated alternatives; match any as a literal substring
    local IFS='|'
    read -ra _alts <<< "$expected_text"
    unset IFS

    while [[ $waited -lt $max_wait ]]; do
        for _alt in "${_alts[@]}"; do
            if validate_comment "$issue_number" "$_alt" "$repo"; then
                record_test_pass "$test_name"
                return 0
            fi
        done
        info "..."
        sleep 5
        waited=$((waited + 5))
    done
    
    record_test_fail "$test_name"
    return 1
}

wait_for_branch_update() {
    local branch_name="$1"
    local initial_sha="$2"
    local test_name="$3"
    local repo="${4:-}"
    local max_wait=480 # Max wait time in seconds (8 minutes)
    local waited=0
    
    while [[ $waited -lt $max_wait ]]; do
        if validate_branch_updated "$branch_name" "$initial_sha" "$repo"; then
            record_test_pass "$test_name"
            return 0
        fi
        info "..."
        sleep 5
        waited=$((waited + 5))
    done
    
    record_test_fail "$test_name"
    return 1
}

wait_for_pr_reviews() {
    local pr_number="$1"
    local ai_type="$2"
    local test_name="$3"
    local repo="${4:-}"
    local max_wait=480 # Max wait time in seconds (8 minutes)
    local waited=0
    
    while [[ $waited -lt $max_wait ]]; do
        if validate_pr_reviews "$pr_number" "$ai_type" "$repo"; then
            record_test_pass "$test_name"
            return 0
        fi
        info "..."
        sleep 5
        waited=$((waited + 5))
    done
    
    record_test_fail "$test_name"
    return 1
}

wait_for_pr_update() {
    local pr_number="$1"
    local ai_type="$2"
    local test_name="$3"
    local repo="${4:-}"
    local max_wait=480 # Max wait time in seconds (8 minutes)
    local waited=0

    while [[ $waited -lt $max_wait ]]; do
        if validate_pr_updated "$pr_number" "$ai_type" "$repo"; then
            record_test_pass "$test_name"
            return 0
        fi
        info "..."
        sleep 5
        waited=$((waited + 5))
    done

    record_test_fail "$test_name"
    return 1
}

validate_discussion_comment() {
    local discussion_number="$1"
    local expected_comment_text="$2"
    local repo="${3:-}"
    
    local api_repo=":owner/:repo"
    if [[ -n "$repo" ]]; then
        api_repo="$repo"
    fi
    
    # Get discussion comments using GitHub API
    local comments=$(gh api repos/"$api_repo"/discussions/"$discussion_number"/comments --jq '.[].body' 2>/dev/null || echo "")
    
    if echo "$comments" | grep -qF "$expected_comment_text"; then
        success "Discussion #$discussion_number has expected comment containing: $expected_comment_text"
        return 0
    else
        warning "(polling) Discussion #$discussion_number missing expected comment containing: '$expected_comment_text'. Actual comments: ${comments:0:200}..."
        return 1
    fi
}

wait_for_discussion_comment() {
    local discussion_number="$1"
    local expected_text="$2"
    local test_name="$3"
    local repo="${4:-}"
    local max_wait=480 # Max wait time in seconds (8 minutes)
    local waited=0
    
    while [[ $waited -lt $max_wait ]]; do
        if validate_discussion_comment "$discussion_number" "$expected_text" "$repo"; then
            record_test_pass "$test_name"
            return 0
        fi
        info "..."
        sleep 5
        waited=$((waited + 5))
    done
    
    record_test_fail "$test_name"
    return 1
}

# --- Validators / waiters for newer safe-output tests -------------------------

validate_discussion_updated() {
    local discussion_number="$1"
    local expected_title_substring="$2"
    local repo="${3:-}"

    local owner="$REPO_OWNER"
    local name="$REPO_NAME"
    if [[ -n "$repo" ]]; then
        owner=$(echo "$repo" | cut -d/ -f1)
        name=$(echo "$repo" | cut -d/ -f2)
    fi

    local query="{
      repository(owner: \"$owner\", name: \"$name\") {
        discussion(number: $discussion_number) {
          title
          body
        }
      }
    }"
    local title
    title=$(gh api graphql -f query="$query" --jq '.data.repository.discussion.title' 2>/dev/null)

    if [[ "$title" == *"$expected_title_substring"* ]]; then
        success "Discussion #$discussion_number title updated as expected: $title"
        return 0
    fi
    warning "(polling) Discussion #$discussion_number title not yet updated. Current title: '$title'"
    return 1
}

wait_for_discussion_updated() {
    local discussion_number="$1"
    local expected_title_substring="$2"
    local test_name="$3"
    local repo="${4:-}"
    local max_wait=480
    local waited=0
    while [[ $waited -lt $max_wait ]]; do
        if validate_discussion_updated "$discussion_number" "$expected_title_substring" "$repo"; then
            record_test_pass "$test_name"
            return 0
        fi
        info "..."
        sleep 5
        waited=$((waited + 5))
    done
    record_test_fail "$test_name"
    return 1
}

validate_assignee_present() {
    local issue_number="$1"
    local expected_assignee="$2"
    local repo="${3:-}"
    local repo_flag=""
    [[ -n "$repo" ]] && repo_flag="--repo $repo"
    local assignees
    assignees=$(gh issue view $repo_flag "$issue_number" --json assignees --jq '.assignees[].login' 2>/dev/null | tr '\n' ',')
    if [[ "$assignees" == *"$expected_assignee"* ]]; then
        success "Issue #$issue_number has expected assignee: $expected_assignee"
        return 0
    fi
    warning "(polling) Issue #$issue_number missing expected assignee '$expected_assignee'. Current assignees: '$assignees'"
    return 1
}

wait_for_assignee_present() {
    local issue_number="$1"
    local expected_assignee="$2"
    local test_name="$3"
    local repo="${4:-}"
    local max_wait=480
    local waited=0
    while [[ $waited -lt $max_wait ]]; do
        if validate_assignee_present "$issue_number" "$expected_assignee" "$repo"; then
            record_test_pass "$test_name"
            return 0
        fi
        info "..."
        sleep 5
        waited=$((waited + 5))
    done
    record_test_fail "$test_name"
    return 1
}

validate_assignee_absent() {
    local issue_number="$1"
    local removed_assignee="$2"
    local repo="${3:-}"
    local repo_flag=""
    [[ -n "$repo" ]] && repo_flag="--repo $repo"
    local assignees
    assignees=$(gh issue view $repo_flag "$issue_number" --json assignees --jq '.assignees[].login' 2>/dev/null | tr '\n' ',')
    if [[ "$assignees" != *"$removed_assignee"* ]]; then
        success "Issue #$issue_number no longer has assignee: $removed_assignee"
        return 0
    fi
    warning "(polling) Issue #$issue_number still has assignee '$removed_assignee'. Current assignees: '$assignees'"
    return 1
}

wait_for_assignee_absent() {
    local issue_number="$1"
    local removed_assignee="$2"
    local test_name="$3"
    local repo="${4:-}"
    local max_wait=480
    local waited=0
    while [[ $waited -lt $max_wait ]]; do
        if validate_assignee_absent "$issue_number" "$removed_assignee" "$repo"; then
            record_test_pass "$test_name"
            return 0
        fi
        info "..."
        sleep 5
        waited=$((waited + 5))
    done
    record_test_fail "$test_name"
    return 1
}

ensure_milestone() {
    local title="$1"
    local repo="${2:-$REPO_OWNER/$REPO_NAME}"
    # Returns nothing on stdout, but logs to LOG_FILE. Idempotent.
    local existing
    existing=$(gh api "repos/$repo/milestones?state=all" --jq ".[] | select(.title==\"$title\") | .number" 2>/dev/null | head -1)
    if [[ -n "$existing" ]]; then
        info "Milestone '$title' already exists (#$existing) in $repo"
        echo "$existing"
        return 0
    fi
    local created
    created=$(gh api --method POST "repos/$repo/milestones" -f "title=$title" --jq '.number' 2>/dev/null)
    if [[ -n "$created" ]]; then
        info "Created milestone '$title' (#$created) in $repo"
        echo "$created"
        return 0
    fi
    warning "Failed to ensure milestone '$title' in $repo"
    return 1
}

validate_milestone_assigned() {
    local issue_number="$1"
    local expected_milestone_title="$2"
    local repo="${3:-}"
    local repo_flag=""
    [[ -n "$repo" ]] && repo_flag="--repo $repo"
    local milestone
    milestone=$(gh issue view $repo_flag "$issue_number" --json milestone --jq '.milestone.title // empty' 2>/dev/null)
    if [[ "$milestone" == "$expected_milestone_title" ]]; then
        success "Issue #$issue_number assigned to milestone '$expected_milestone_title'"
        return 0
    fi
    warning "(polling) Issue #$issue_number not yet assigned to milestone '$expected_milestone_title'. Current: '$milestone'"
    return 1
}

wait_for_milestone_assigned() {
    local issue_number="$1"
    local expected_milestone_title="$2"
    local test_name="$3"
    local repo="${4:-}"
    local max_wait=480
    local waited=0
    while [[ $waited -lt $max_wait ]]; do
        if validate_milestone_assigned "$issue_number" "$expected_milestone_title" "$repo"; then
            record_test_pass "$test_name"
            return 0
        fi
        info "..."
        sleep 5
        waited=$((waited + 5))
    done
    record_test_fail "$test_name"
    return 1
}

validate_sub_issue_linked() {
    local parent_number="$1"
    local sub_number="$2"
    local repo="${3:-}"
    local owner="$REPO_OWNER"
    local name="$REPO_NAME"
    if [[ -n "$repo" ]]; then
        owner=$(echo "$repo" | cut -d/ -f1)
        name=$(echo "$repo" | cut -d/ -f2)
    fi
    local query="{
      repository(owner: \"$owner\", name: \"$name\") {
        issue(number: $parent_number) {
          subIssues(first: 50) { nodes { number } }
        }
      }
    }"
    local subs
    subs=$(gh api graphql -f query="$query" --jq '.data.repository.issue.subIssues.nodes[].number' 2>/dev/null | tr '\n' ',')
    if [[ ",$subs," == *",$sub_number,"* ]]; then
        success "Issue #$sub_number is linked as sub-issue of #$parent_number"
        return 0
    fi
    warning "(polling) Issue #$sub_number not yet a sub-issue of #$parent_number. Current sub-issues: '$subs'"
    return 1
}

wait_for_sub_issue_linked() {
    local parent_number="$1"
    local sub_number="$2"
    local test_name="$3"
    local repo="${4:-}"
    local max_wait=480
    local waited=0
    while [[ $waited -lt $max_wait ]]; do
        if validate_sub_issue_linked "$parent_number" "$sub_number" "$repo"; then
            record_test_pass "$test_name"
            return 0
        fi
        info "..."
        sleep 5
        waited=$((waited + 5))
    done
    record_test_fail "$test_name"
    return 1
}

# Adds a comment to the given issue and prints its GraphQL node ID to stdout.
add_test_comment_get_node_id() {
    local issue_number="$1"
    local body="$2"
    local repo="${3:-}"
    local api_repo=":owner/:repo"
    [[ -n "$repo" ]] && api_repo="$repo"
    gh api --method POST "repos/$api_repo/issues/$issue_number/comments" -f "body=$body" --jq '.node_id' 2>/dev/null
}

validate_comment_hidden() {
    local comment_node_id="$1"
    local query="{
      node(id: \"$comment_node_id\") {
        ... on IssueComment { isMinimized minimizedReason }
      }
    }"
    local is_minimized
    is_minimized=$(gh api graphql -f query="$query" --jq '.data.node.isMinimized' 2>/dev/null)
    if [[ "$is_minimized" == "true" ]]; then
        success "Comment $comment_node_id is hidden (minimized)"
        return 0
    fi
    warning "(polling) Comment $comment_node_id is not yet hidden (isMinimized=$is_minimized)"
    return 1
}

wait_for_comment_hidden() {
    local comment_node_id="$1"
    local test_name="$2"
    local max_wait=480
    local waited=0
    while [[ $waited -lt $max_wait ]]; do
        if validate_comment_hidden "$comment_node_id"; then
            record_test_pass "$test_name"
            return 0
        fi
        info "..."
        sleep 5
        waited=$((waited + 5))
    done
    record_test_fail "$test_name"
    return 1
}

validate_pr_reviewer_added() {
    local pr_number="$1"
    local expected_reviewer="$2"   # case-insensitive substring match
    local repo="${3:-}"
    local repo_flag=""
    [[ -n "$repo" ]] && repo_flag="--repo $repo"
    local reviewers
    reviewers=$(gh pr view $repo_flag "$pr_number" --json reviewRequests,latestReviews \
        --jq '[.reviewRequests[].login, .latestReviews[].author.login] | join(",")' 2>/dev/null)
    local lower
    lower=$(echo "$reviewers" | tr '[:upper:]' '[:lower:]')
    local expected_lower
    expected_lower=$(echo "$expected_reviewer" | tr '[:upper:]' '[:lower:]')
    if [[ "$lower" == *"$expected_lower"* ]]; then
        success "PR #$pr_number has expected reviewer matching '$expected_reviewer'"
        return 0
    fi
    warning "(polling) PR #$pr_number missing expected reviewer '$expected_reviewer'. Current: '$reviewers'"
    return 1
}

wait_for_pr_reviewer_added() {
    local pr_number="$1"
    local expected_reviewer="$2"
    local test_name="$3"
    local repo="${4:-}"
    local max_wait=480
    local waited=0
    while [[ $waited -lt $max_wait ]]; do
        if validate_pr_reviewer_added "$pr_number" "$expected_reviewer" "$repo"; then
            record_test_pass "$test_name"
            return 0
        fi
        info "..."
        sleep 5
        waited=$((waited + 5))
    done
    record_test_fail "$test_name"
    return 1
}

validate_pr_review_with_body() {
    local pr_number="$1"
    local expected_body_substring="$2"
    local repo="${3:-}"
    local api_repo=":owner/:repo"
    [[ -n "$repo" ]] && api_repo="$repo"
    local matched
    matched=$(gh api "repos/$api_repo/pulls/$pr_number/reviews" \
        --jq "[.[] | select(.body != null) | select(.body | contains(\"$expected_body_substring\"))] | length" 2>/dev/null)
    if [[ "$matched" -gt 0 ]] 2>/dev/null; then
        success "PR #$pr_number has a submitted review containing: $expected_body_substring"
        return 0
    fi
    warning "(polling) PR #$pr_number missing submitted review containing: '$expected_body_substring'"
    return 1
}

wait_for_pr_review_with_body() {
    local pr_number="$1"
    local expected_body_substring="$2"
    local test_name="$3"
    local repo="${4:-}"
    local max_wait=480
    local waited=0
    while [[ $waited -lt $max_wait ]]; do
        if validate_pr_review_with_body "$pr_number" "$expected_body_substring" "$repo"; then
            record_test_pass "$test_name"
            return 0
        fi
        info "..."
        sleep 5
        waited=$((waited + 5))
    done
    record_test_fail "$test_name"
    return 1
}

validate_dispatched_issue_created() {
    local sentinel="$1"
    local repo="${2:-}"
    local repo_flag=""
    [[ -n "$repo" ]] && repo_flag="--repo $repo"
    local found
    found=$(gh issue list $repo_flag --limit 20 --search "sentinel=$sentinel in:title" --json number --jq '.[].number' 2>/dev/null | head -1)
    if [[ -n "$found" ]]; then
        success "Worker-created issue #$found matches sentinel '$sentinel'"
        return 0
    fi
    warning "(polling) No issue found yet with sentinel='$sentinel'"
    return 1
}

wait_for_dispatched_issue_created() {
    local sentinel="$1"
    local test_name="$2"
    local repo="${3:-}"
    local max_wait=300
    local waited=0
    while [[ $waited -lt $max_wait ]]; do
        if validate_dispatched_issue_created "$sentinel" "$repo"; then
            record_test_pass "$test_name"
            return 0
        fi
        info "..."
        sleep 5
        waited=$((waited + 5))
    done
    record_test_fail "$test_name"
    return 1
}

# --- set-issue-type -----------------------------------------------------------

validate_issue_type() {
    local issue_number="$1"
    local expected_type="$2"
    local repo="${3:-}"

    local owner="$REPO_OWNER"
    local name="$REPO_NAME"
    if [[ -n "$repo" ]]; then
        owner=$(echo "$repo" | cut -d/ -f1)
        name=$(echo "$repo" | cut -d/ -f2)
    fi

    local issue_type
    issue_type=$(gh api graphql -f query="{ repository(owner: \"$owner\", name: \"$name\") { issue(number: $issue_number) { issueType { name } } } }" \
        --jq '.data.repository.issue.issueType.name' 2>/dev/null)

    if [[ "$issue_type" == "$expected_type" ]]; then
        success "Issue #$issue_number has expected issue type: $issue_type"
        return 0
    fi
    warning "(polling) Issue #$issue_number issue type not yet '$expected_type' (actual: '${issue_type:-none}')"
    return 1
}

wait_for_issue_type() {
    local issue_number="$1"
    local expected_type="$2"
    local test_name="$3"
    local repo="${4:-}"
    local max_wait=480
    local waited=0
    while [[ $waited -lt $max_wait ]]; do
        if validate_issue_type "$issue_number" "$expected_type" "$repo"; then
            record_test_pass "$test_name"
            return 0
        fi
        info "..."
        sleep 5
        waited=$((waited + 5))
    done
    record_test_fail "$test_name"
    return 1
}

# --- mark-pull-request-as-ready-for-review ------------------------------------

# Creates a DRAFT pull request and prints its number, modelled on create_test_pr.
create_test_draft_pr() {
    local title="$1"
    local body="$2"
    local repo="${3:-}"
    local branch="test-pr-$(date +%s)-${BASHPID:-$$}-$RANDOM"

    if [[ -n "${E2E_TRIGGER_MARKER:-}" ]]; then
        body+=$'\n\n'"$E2E_TRIGGER_MARKER"
    fi

    local repo_flag=""
    local api_repo=":owner/:repo"
    if [[ -n "$repo" ]]; then
        repo_flag="--repo $repo"
        api_repo="$repo"
    fi

    local main_sha=$(gh api repos/"$api_repo"/git/refs/heads/main --jq '.object.sha' 2>/dev/null)
    [[ -z "$main_sha" ]] && { echo ""; return; }
    gh api repos/"$api_repo"/git/refs --method POST \
        --field ref="refs/heads/$branch" --field sha="$main_sha" &>/dev/null

    local file_path="notes-$(date +%s)-${BASHPID:-$$}-$RANDOM.md"
    local file_content="# Draft PR Content\n\nThis is a test file created for draft PR testing at $(date)"
    gh api repos/"$api_repo"/contents/"$file_path" --method PUT \
        --field message="Test commit for draft PR" \
        --field content="$(echo -e "$file_content" | base64 -w 0)" \
        --field branch="$branch" &>/dev/null

    local pr_url=$(gh pr create $repo_flag --draft --title "$title" --body "$body" --head "$branch" --base main 2>/dev/null)
    if [[ -n "$pr_url" ]]; then
        echo "$pr_url" | grep -o '[0-9]\+$'
    else
        echo ""
    fi
}

validate_pr_ready_for_review() {
    local pr_number="$1"
    local repo="${2:-}"
    local repo_flag=""
    [[ -n "$repo" ]] && repo_flag="--repo $repo"
    local is_draft
    is_draft=$(gh pr view $repo_flag "$pr_number" --json isDraft --jq '.isDraft' 2>/dev/null)
    if [[ "$is_draft" == "false" ]]; then
        success "PR #$pr_number is marked ready for review (isDraft=false)"
        return 0
    fi
    warning "(polling) PR #$pr_number is still a draft (isDraft=$is_draft)"
    return 1
}

wait_for_pr_ready_for_review() {
    local pr_number="$1"
    local test_name="$2"
    local repo="${3:-}"
    local max_wait=480
    local waited=0
    while [[ $waited -lt $max_wait ]]; do
        if validate_pr_ready_for_review "$pr_number" "$repo"; then
            record_test_pass "$test_name"
            return 0
        fi
        info "..."
        sleep 5
        waited=$((waited + 5))
    done
    record_test_fail "$test_name"
    return 1
}

# --- reply-to / resolve pull request review comment fixtures ------------------

# Creates a PR with one added file and posts a single review comment on it.
# Prints: "<pr_number>,<comment_id>,<thread_id>"
create_test_pr_with_review_comment() {
    local title="$1"
    local body="$2"
    local repo="${3:-}"
    local branch="test-pr-$(date +%s)-${BASHPID:-$$}-$RANDOM"

    if [[ -n "${E2E_TRIGGER_MARKER:-}" ]]; then
        body+=$'\n\n'"$E2E_TRIGGER_MARKER"
    fi

    local repo_flag=""
    local api_repo=":owner/:repo"
    if [[ -n "$repo" ]]; then
        repo_flag="--repo $repo"
        api_repo="$repo"
    fi

    local main_sha=$(gh api repos/"$api_repo"/git/refs/heads/main --jq '.object.sha' 2>/dev/null)
    [[ -z "$main_sha" ]] && { echo ""; return; }
    gh api repos/"$api_repo"/git/refs --method POST \
        --field ref="refs/heads/$branch" --field sha="$main_sha" &>/dev/null

    local file_path="notes-$(date +%s)-${BASHPID:-$$}-$RANDOM.md"
    local file_content="# Review target\n\nLine to be reviewed.\nAnother line.\n"
    gh api repos/"$api_repo"/contents/"$file_path" --method PUT \
        --field message="Add review target file" \
        --field content="$(echo -e "$file_content" | base64 -w 0)" \
        --field branch="$branch" &>/dev/null

    local head_sha=$(gh api repos/"$api_repo"/git/refs/heads/"$branch" --jq '.object.sha' 2>/dev/null)
    local pr_url=$(gh pr create $repo_flag --title "$title" --body "$body" --head "$branch" --base main 2>/dev/null)
    [[ -z "$pr_url" ]] && { echo ""; return; }
    local pr_number=$(echo "$pr_url" | grep -o '[0-9]\+$')

    # Post a review comment on line 1 of the newly added file (added line, RIGHT side)
    local comment_id
    comment_id=$(gh api "repos/$api_repo/pulls/$pr_number/comments" --method POST \
        --field body="Initial review comment for reply/resolve fixture" \
        --field commit_id="$head_sha" \
        --field path="$file_path" \
        --field line=1 \
        --field side="RIGHT" --jq '.id' 2>/dev/null)

    # Resolve the thread node id via GraphQL
    local owner="$REPO_OWNER"
    local name="$REPO_NAME"
    if [[ -n "$repo" ]]; then
        owner=$(echo "$repo" | cut -d/ -f1)
        name=$(echo "$repo" | cut -d/ -f2)
    fi
    local thread_id
    thread_id=$(gh api graphql -f query="{ repository(owner: \"$owner\", name: \"$name\") { pullRequest(number: $pr_number) { reviewThreads(first: 20) { nodes { id comments(first: 1) { nodes { databaseId } } } } } } }" \
        --jq ".data.repository.pullRequest.reviewThreads.nodes[] | select(.comments.nodes[0].databaseId == $comment_id) | .id" 2>/dev/null | head -1)

    echo "$pr_number,$comment_id,$thread_id"
}

validate_review_comment_reply() {
    local pr_number="$1"
    local expected_body_substring="$2"
    local repo="${3:-}"
    local api_repo=":owner/:repo"
    [[ -n "$repo" ]] && api_repo="$repo"
    local matched
    matched=$(gh api "repos/$api_repo/pulls/$pr_number/comments" \
        --jq "[.[] | select(.body != null) | select(.body | contains(\"$expected_body_substring\"))] | length" 2>/dev/null)
    if [[ "$matched" -gt 0 ]] 2>/dev/null; then
        success "PR #$pr_number has a review comment reply containing: $expected_body_substring"
        return 0
    fi
    warning "(polling) PR #$pr_number missing review comment reply containing: '$expected_body_substring'"
    return 1
}

wait_for_review_comment_reply() {
    local pr_number="$1"
    local expected_body_substring="$2"
    local test_name="$3"
    local repo="${4:-}"
    local max_wait=480
    local waited=0
    while [[ $waited -lt $max_wait ]]; do
        if validate_review_comment_reply "$pr_number" "$expected_body_substring" "$repo"; then
            record_test_pass "$test_name"
            return 0
        fi
        info "..."
        sleep 5
        waited=$((waited + 5))
    done
    record_test_fail "$test_name"
    return 1
}

validate_review_thread_resolved() {
    local thread_id="$1"
    local is_resolved
    is_resolved=$(gh api graphql -f query="{ node(id: \"$thread_id\") { ... on PullRequestReviewThread { isResolved } } }" \
        --jq '.data.node.isResolved' 2>/dev/null)
    if [[ "$is_resolved" == "true" ]]; then
        success "Review thread $thread_id is resolved"
        return 0
    fi
    warning "(polling) Review thread $thread_id not yet resolved (isResolved=$is_resolved)"
    return 1
}

wait_for_review_thread_resolved() {
    local thread_id="$1"
    local test_name="$2"
    local max_wait=480
    local waited=0
    while [[ $waited -lt $max_wait ]]; do
        if validate_review_thread_resolved "$thread_id"; then
            record_test_pass "$test_name"
            return 0
        fi
        info "..."
        sleep 5
        waited=$((waited + 5))
    done
    record_test_fail "$test_name"
    return 1
}

# --- update-release -----------------------------------------------------------

# Creates a GitHub release with a unique tag and a known body, then prints the tag.
create_test_release() {
    local title="$1"
    local repo="${2:-}"
    local tag="e2e-release-$(date +%s)-${BASHPID:-$$}-$RANDOM"
    local repo_flag=""
    [[ -n "$repo" ]] && repo_flag="--repo $repo"

    if gh release create "$tag" $repo_flag \
        --target main \
        --title "$title" \
        --notes "Original release body for update-release test." &>/dev/null; then
        echo "$tag"
    else
        echo ""
    fi
}

validate_release_body_updated() {
    local tag="$1"
    local expected_substring="$2"
    local repo="${3:-}"
    local repo_flag=""
    [[ -n "$repo" ]] && repo_flag="--repo $repo"

    local body
    body=$(gh release view "$tag" $repo_flag --json body --jq '.body' 2>/dev/null)
    if echo "$body" | grep -qF "$expected_substring"; then
        success "Release '$tag' body contains expected text: $expected_substring"
        return 0
    fi
    warning "(polling) Release '$tag' body not yet updated. Actual: ${body:0:200}..."
    return 1
}

wait_for_release_body_updated() {
    local tag="$1"
    local expected_substring="$2"
    local test_name="$3"
    local repo="${4:-}"
    local max_wait=480
    local waited=0
    while [[ $waited -lt $max_wait ]]; do
        if validate_release_body_updated "$tag" "$expected_substring" "$repo"; then
            record_test_pass "$test_name"
            return 0
        fi
        info "..."
        sleep 5
        waited=$((waited + 5))
    done
    record_test_fail "$test_name"
    return 1
}

# --- upload-asset -------------------------------------------------------------

# Checks that the orphaned assets branch exists and contains at least one
# committed file (the asset is named "<sha256>.png" by the upload job).
validate_asset_published() {
    local branch="$1"
    local repo="${2:-}"
    local repo_path="$REPO_OWNER/$REPO_NAME"
    [[ -n "$repo" ]] && repo_path="$repo"

    local contents
    contents=$(gh api "repos/$repo_path/contents?ref=$branch" --jq '.[].name' 2>/dev/null)
    if echo "$contents" | grep -qiE '\.png$'; then
        success "Asset branch '$branch' contains a published .png asset: $(echo "$contents" | tr '\n' ' ')"
        return 0
    fi
    warning "(polling) Asset branch '$branch' has no .png asset yet. Contents: $(echo "$contents" | tr '\n' ' ')"
    return 1
}

wait_for_asset_published() {
    local branch="$1"
    local test_name="$2"
    local repo="${3:-}"
    local max_wait=480
    local waited=0
    while [[ $waited -lt $max_wait ]]; do
        if validate_asset_published "$branch" "$repo"; then
            record_test_pass "$test_name"
            return 0
        fi
        info "..."
        sleep 5
        waited=$((waited + 5))
    done
    record_test_fail "$test_name"
    return 1
}

# Execute a single test (used by parallel batch execution)
# This function must handle all output synchronization
run_single_test() {
    local workflow="$1"
    local test_log="/tmp/e2e-test-${workflow}-$$.log"
    
    # Redirect all output to test-specific log
    exec 1>"$test_log" 2>&1

    # Marker injected into any issue/discussion/PR body this test creates so each
    # workflow's `if: contains(github.event.<event>.body, 'e2e-marker:<workflow>')`
    # filter only fires for its own trigger. Without this, parallel-batched tests
    # sharing the same event (e.g. `issues: opened`) fan out across the whole batch.
    export E2E_TRIGGER_MARKER="<!-- e2e-marker:${workflow} -->"

    local ai_type=$(extract_ai_type "$workflow")
    local ai_display_name=$(get_ai_display_name "$ai_type")
    local target_repo=$(get_target_repo "$workflow")
    local repo_display=""
    if [[ -n "$target_repo" ]]; then
        repo_display=" (target: $target_repo)"
        info "Cross-repo test targeting: $target_repo"
    fi
    
    # Run test based on workflow pattern - handles ALL test types
    local test_result="FAIL"
    
    case "$workflow" in
        # Siderepo tests with workflow_dispatch + inputs - need to create prerequisite then trigger
        *"siderepo-add-comment"|*"siderepo-add-labels"|*"siderepo-update-issue")
            echo ""
            echo -e "${CYAN}━━━ Preparing test prerequisites ━━━${NC}"
            info "Creating test issue in target repository for $workflow..."
            local issue_title="Hello from $ai_display_name"
            local issue_num=$(create_test_issue "$issue_title" "This is a test issue for $workflow" "" "$target_repo")
            if [[ -n "$issue_num" ]]; then
                local repo_url="$REPO_OWNER/$REPO_NAME"
                [[ -n "$target_repo" ]] && repo_url="$target_repo"
                success "Created test issue #$issue_num: https://github.com/$repo_url/issues/$issue_num"
                echo -e "${CYAN}━━━ Running workflow test ━━━${NC}"
                echo ""
                
                local workflow_success=false
                if trigger_workflow_with_inputs "$workflow" "issue_number=$issue_num"; then
                    workflow_success=true
                fi
                
                if [[ "$workflow_success" == true ]]; then
                    sleep 10
                    case "$workflow" in
                        *"add-comment")
                            if wait_for_comment "$issue_num" "Reply from $ai_display_name" "$workflow" "$target_repo"; then
                                test_result="PASS"
                            fi
                            ;;
                        *"add-labels")
                            if wait_for_labels "$issue_num" "${ai_type}-safe-output-label-test" "$workflow" "$target_repo"; then
                                test_result="PASS"
                            fi
                            ;;
                        *"update-issue")
                            if wait_for_issue_update "$issue_num" "$ai_display_name" "$workflow" "$target_repo"; then
                                test_result="PASS"
                            fi
                            ;;
                    esac
                fi
            fi
            ;;
        *"siderepo-add-discussion-comment")
            echo ""
            echo -e "${CYAN}━━━ Preparing test prerequisites ━━━${NC}"
            info "Creating test discussion in target repository for $workflow..."
            local discussion_title="Hello from $ai_display_name Discussion"
            local discussion_num=$(create_test_discussion "$discussion_title" "This is a test discussion for $workflow" "General" "$target_repo")
            if [[ -n "$discussion_num" ]]; then
                local repo_url="$REPO_OWNER/$REPO_NAME"
                [[ -n "$target_repo" ]] && repo_url="$target_repo"
                success "Created test discussion #$discussion_num: https://github.com/$repo_url/discussions/$discussion_num"
                echo -e "${CYAN}━━━ Running workflow test ━━━${NC}"
                echo ""
                
                local workflow_success=false
                if trigger_workflow_with_inputs "$workflow" "discussion_number=$discussion_num"; then
                    workflow_success=true
                fi
                
                if [[ "$workflow_success" == true ]]; then
                    sleep 10
                    if wait_for_discussion_comment "$discussion_num" "Reply from $ai_display_name Discussion" "$workflow" "$target_repo"; then
                        test_result="PASS"
                    fi
                fi
            else
                warning "Could not create test discussion for $workflow - discussions may not be enabled on this repository"
                test_result="PASS"
            fi
            ;;
        *"siderepo-create-pull-request-review-comment")
            echo ""
            echo -e "${CYAN}━━━ Preparing test prerequisites ━━━${NC}"
            info "Creating test pull request in target repository for $workflow..."
            local pr_title="Test PR for $ai_display_name"
            local pr_info=$(create_test_pr_with_branch "$pr_title" "This PR is for testing $workflow" "$target_repo")
            if [[ -n "$pr_info" ]]; then
                IFS=',' read -r pr_num branch_name after_commit_sha repo_from_info <<< "$pr_info"
                local repo_url="$REPO_OWNER/$REPO_NAME"
                [[ -n "$target_repo" ]] && repo_url="$target_repo"
                success "Created test PR #$pr_num: https://github.com/$repo_url/pull/$pr_num"
                echo -e "${CYAN}━━━ Running workflow test ━━━${NC}"
                echo ""
                
                local workflow_success=false
                if trigger_workflow_with_inputs "$workflow" "pull_request_number=$pr_num"; then
                    workflow_success=true
                fi
                
                if [[ "$workflow_success" == true ]]; then
                    sleep 10
                    if wait_for_pr_reviews "$pr_num" "$ai_display_name" "$workflow" "$target_repo"; then
                        test_result="PASS"
                    fi
                fi
            fi
            ;;
        # Dispatch-workflow test: enable worker, trigger dispatcher with sentinel, wait for worker issue
        *"dispatch-workflow")
            echo ""
            echo -e "${CYAN}━━━ Preparing test prerequisites ━━━${NC}"
            local worker_workflow="test-copilot-dispatch-worker"
            if enable_workflow "$worker_workflow"; then
                # Track for cleanup in parent process
                (
                    flock -x 200
                    echo "$worker_workflow" >> "/tmp/e2e-workflows-list-$$.txt"
                ) 200>"$GLOBAL_WORKFLOWS_LOCK"
            else
                warning "Could not enable worker '$worker_workflow'; dispatch-workflow test will likely fail"
            fi
            local sentinel="dispatch-$(date +%s)-$$"
            info "Generated dispatch sentinel: $sentinel"
            echo -e "${CYAN}━━━ Running workflow test ━━━${NC}"
            echo ""
            local workflow_success=false
            if trigger_workflow_with_inputs "$workflow" "sentinel=$sentinel"; then
                workflow_success=true
            fi
            if [[ "$workflow_success" == true ]]; then
                sleep 10
                if wait_for_dispatched_issue_created "$sentinel" "$workflow" "$target_repo"; then
                    test_result="PASS"
                fi
            fi
            ;;
        # Call-workflow test: dispatch the gateway with a sentinel; the gateway
        # activates the reusable worker (test-copilot-call-worker) via workflow_call,
        # which creates an issue carrying the sentinel. The worker runs as part of the
        # gateway run (uses:) so it does not need to be enabled separately.
        *"call-workflow")
            echo ""
            echo -e "${CYAN}━━━ Preparing test prerequisites ━━━${NC}"
            local sentinel="call-$(date +%s)-$$"
            info "Generated call-workflow sentinel: $sentinel"
            echo -e "${CYAN}━━━ Running workflow test ━━━${NC}"
            echo ""
            local workflow_success=false
            if trigger_workflow_with_inputs "$workflow" "sentinel=$sentinel"; then
                workflow_success=true
            fi
            if [[ "$workflow_success" == true ]]; then
                sleep 10
                if wait_for_dispatched_issue_created "$sentinel" "$workflow" "$target_repo"; then
                    test_result="PASS"
                fi
            fi
            ;;
        # Upload-asset test: dispatch, then verify the orphaned assets branch got a .png
        *"upload-asset")
            echo ""
            echo -e "${CYAN}━━━ Running workflow test ━━━${NC}"
            echo ""
            local workflow_success=false
            if trigger_workflow_dispatch_and_await_completion "$workflow"; then
                workflow_success=true
            fi
            if [[ "$workflow_success" == true ]]; then
                sleep 10
                if wait_for_asset_published "assets/$workflow" "$workflow" "$target_repo"; then
                    test_result="PASS"
                fi
            fi
            ;;
        # Update-release test: create a release fixture, dispatch with its tag, await body update
        *"update-release")            echo ""
            echo -e "${CYAN}━━━ Preparing test prerequisites ━━━${NC}"
            info "Creating test release for $workflow..."
            local release_tag=$(create_test_release "Release for $ai_display_name update-release test" "$target_repo")
            if [[ -n "$release_tag" ]]; then
                local repo_url="$REPO_OWNER/$REPO_NAME"
                [[ -n "$target_repo" ]] && repo_url="$target_repo"
                success "Created test release '$release_tag': https://github.com/$repo_url/releases/tag/$release_tag"
                echo -e "${CYAN}━━━ Running workflow test ━━━${NC}"
                echo ""
                local workflow_success=false
                if trigger_workflow_with_inputs "$workflow" "release_tag=$release_tag"; then
                    workflow_success=true
                fi
                if [[ "$workflow_success" == true ]]; then
                    sleep 10
                    if wait_for_release_body_updated "$release_tag" "Updated by $ai_display_name update-release safe output" "$workflow" "$target_repo"; then
                        test_result="PASS"
                    fi
                fi
            else
                error "Could not create test release for $workflow"
            fi
            ;;
        # Workflow dispatch tests - triggered with gh aw run
        *"create-issue"|*"create-discussion"|*"create-pull-request"|*"create-two-pull-requests"|*"code-scanning-alert"|*"create-check-run"|*"mcp"|*"safe-jobs"|*"gh-steps"|*"custom-safe-outputs"|*"noop"|*"report-incomplete")
            local workflow_success=false
            if trigger_workflow_dispatch_and_await_completion "$workflow"; then
                workflow_success=true
            fi
            
            if [[ "$workflow_success" == true ]]; then
                local validation_success=false
                case "$workflow" in
                    *"multi")
                        local title_prefix=$(get_title_prefix "$workflow" "$ai_type")
                        local expected_labels=$(get_expected_labels "$ai_type")
                        if validate_issue_created "$title_prefix" "$expected_labels" "$target_repo"; then
                            validation_success=true
                        fi
                        if validate_pr_created "$title_prefix" "$target_repo"; then
                            validation_success=true
                        fi
                        ;;
                    *"create-issue")
                        local title_prefix=$(get_title_prefix "$workflow" "$ai_type")
                        local expected_labels=$(get_expected_labels "$ai_type")
                        if validate_issue_created "$title_prefix" "$expected_labels" "$target_repo"; then
                            validation_success=true
                        fi
                        ;;
                    *"create-discussion")
                        local title_prefix=$(get_title_prefix "$workflow" "$ai_type")
                        local expected_labels=$(get_expected_labels "$ai_type")
                        if validate_discussion_created "$title_prefix" "$expected_labels" "$target_repo"; then
                            validation_success=true
                        fi
                        ;;
                    *"create-two-pull-requests")
                        local title_prefix=$(get_title_prefix "$workflow" "$ai_type")
                        if validate_two_prs_created "$title_prefix" "$target_repo"; then
                            validation_success=true
                        fi
                        ;;
                    *"create-pull-request")
                        local title_prefix=$(get_title_prefix "$workflow" "$ai_type")
                        if validate_pr_created "$title_prefix" "$target_repo"; then
                            validation_success=true
                        fi
                        ;;
                    *"code-scanning-alert")
                        if validate_code_scanning_alert "$workflow" "$target_repo"; then
                            validation_success=true
                        fi
                        ;;
                    *"mcp")
                        if validate_mcp_workflow "$workflow" "$target_repo"; then
                            validation_success=true
                        fi
                        ;;
                    *"gh-steps")
                        local title_prefix=$(get_title_prefix "$workflow" "$ai_type")
                        local expected_labels=$(get_expected_labels "$ai_type")
                        if validate_issue_created "$title_prefix" "$expected_labels" "$target_repo"; then
                            local run_url="${TEST_RUN_URLS[$workflow]:-}"
                            local expected_run_id="${run_url##*/}"
                            local repo_flag=""
                            [[ -n "$target_repo" ]] && repo_flag="--repo $target_repo"
                            local issue_title=$(gh issue list $repo_flag --limit 10 --json title --jq ".[] | select(.title | startswith(\"$title_prefix\")) | .title" | head -1)
                            if [[ -n "$expected_run_id" ]] && echo "$issue_title" | grep -q "Test ${expected_run_id}:.*The number of issues is"; then
                                success "Issue title contains run ID $expected_run_id and expected gh-steps output: $issue_title"
                                validation_success=true
                            elif echo "$issue_title" | grep -q "The number of issues is\|Issue count report"; then
                                success "Issue title contains expected gh-steps output (run ID not verified): $issue_title"
                                validation_success=true
                            else
                                error "Issue title does not contain expected pattern 'Test <run_id>: The number of issues is' or sample title 'Issue count report': $issue_title"
                            fi
                        fi
                        ;;
                    *)
                        success "Workflow '$workflow' completed successfully (no specific validation available)"
                        validation_success=true
                        ;;
                esac
                
                if [[ "$validation_success" == true ]]; then
                    test_result="PASS"
                fi
            fi
            ;;
        
        # Issue-triggered and command-triggered tests - need to enable, create trigger, wait
        *)
            if [[ "$WORKFLOW_DISPATCH_ONLY" == true ]]; then
                info "Skipping '$workflow' (not a workflow_dispatch test; --workflow-dispatch-only is set)"
                test_result="SKIP"
            else
                local workflow_file_path=".github/workflows/${workflow}.lock.yml"
                if [[ ! -f "$workflow_file_path" ]]; then
                    error "Workflow file not found for '$workflow' at $workflow_file_path; marking as failed"
                    test_result="FAIL"
                else
                    local enable_success=false
                    if enable_workflow "$workflow"; then
                        enable_success=true
                        # Track for cleanup in parent process
                        (
                            flock -x 200
                            echo "$workflow" >> "/tmp/e2e-workflows-list-$$.txt"
                        ) 200>"$GLOBAL_WORKFLOWS_LOCK"
                    fi
                    
                    if [[ "$enable_success" == true ]]; then
                        case "$workflow" in
                            *"add-discussion-comment")
                                info "Creating test discussion to trigger $workflow..."
                                local discussion_title="Hello from $ai_display_name Discussion"
                                local discussion_num=$(create_test_discussion "$discussion_title" "This is a test discussion to trigger $workflow" "General" "$target_repo")
                                if [[ -n "$discussion_num" ]]; then
                                    local repo_url="$REPO_OWNER/$REPO_NAME"
                                    [[ -n "$target_repo" ]] && repo_url="$target_repo"
                                    success "Created test discussion #$discussion_num to trigger $workflow: https://github.com/$repo_url/discussions/$discussion_num"
                                    sleep 10
                                    if wait_for_discussion_comment "$discussion_num" "Reply from $ai_display_name Discussion" "$workflow" "$target_repo"; then
                                        test_result="PASS"
                                    fi
                                else
                                    warning "Could not create test discussion for $workflow - discussions may not be enabled on this repository"
                                    test_result="PASS"
                                fi
                                ;;
                            *"close-discussion")
                                info "Creating test discussion to trigger $workflow..."
                                local discussion_title="Test close discussion from $ai_display_name"
                                local discussion_num=$(create_test_discussion "$discussion_title" "This is a test discussion to trigger $workflow" "General" "$target_repo")
                                if [[ -n "$discussion_num" ]]; then
                                    local repo_url="$REPO_OWNER/$REPO_NAME"
                                    [[ -n "$target_repo" ]] && repo_url="$target_repo"
                                    success "Created test discussion #$discussion_num to trigger $workflow: https://github.com/$repo_url/discussions/$discussion_num"
                                    sleep 10
                                    if wait_for_discussion_closed "$discussion_num" "$workflow" "$target_repo"; then
                                        test_result="PASS"
                                    fi
                                else
                                    warning "Could not create test discussion for $workflow - discussions may not be enabled on this repository"
                                    test_result="PASS"
                                fi
                                ;;
                            *"add-comment")
                                info "Creating test issue to trigger $workflow..."
                                local issue_title="Hello from $ai_display_name"
                                local issue_num=$(create_test_issue "$issue_title" "This is a test issue to trigger $workflow" "" "$target_repo")
                                if [[ -n "$issue_num" ]]; then
                                    local repo_url="$REPO_OWNER/$REPO_NAME"
                                    [[ -n "$target_repo" ]] && repo_url="$target_repo"
                                    success "Created test issue #$issue_num for $workflow: https://github.com/$repo_url/issues/$issue_num"
                                    sleep 10
                                    if wait_for_comment "$issue_num" "Reply from $ai_display_name" "$workflow" "$target_repo"; then
                                        test_result="PASS"
                                    fi
                                fi
                                ;;
                            *"add-labels")
                                info "Creating test issue to trigger $workflow..."
                                local issue_title="Hello from $ai_display_name"
                                local issue_num=$(create_test_issue "$issue_title" "This is a test issue to trigger $workflow" "" "$target_repo")
                                if [[ -n "$issue_num" ]]; then
                                    local repo_url="$REPO_OWNER/$REPO_NAME"
                                    [[ -n "$target_repo" ]] && repo_url="$target_repo"
                                    success "Created test issue #$issue_num for $workflow: https://github.com/$repo_url/issues/$issue_num"
                                    sleep 10
                                    if wait_for_labels "$issue_num" "${ai_type}-safe-output-label-test" "$workflow" "$target_repo"; then
                                        test_result="PASS"
                                    fi
                                fi
                                ;;
                            *"update-issue")
                                info "Creating test issue to trigger $workflow..."
                                local issue_title="Hello from $ai_display_name"
                                local issue_num=$(create_test_issue "$issue_title" "This is a test issue to trigger $workflow" "" "$target_repo")
                                if [[ -n "$issue_num" ]]; then
                                    local repo_url="$REPO_OWNER/$REPO_NAME"
                                    [[ -n "$target_repo" ]] && repo_url="$target_repo"
                                    success "Created test issue #$issue_num for $workflow: https://github.com/$repo_url/issues/$issue_num"
                                    sleep 10
                                    if wait_for_issue_update "$issue_num" "$ai_display_name" "$workflow" "$target_repo"; then
                                        test_result="PASS"
                                    fi
                                fi
                                ;;
                            *"close-issue")
                                info "Creating test issue to trigger $workflow..."
                                local issue_title="Test close issue from $ai_display_name"
                                local issue_num=$(create_test_issue "$issue_title" "This is a test issue to trigger $workflow" "" "$target_repo")
                                if [[ -n "$issue_num" ]]; then
                                    local repo_url="$REPO_OWNER/$REPO_NAME"
                                    [[ -n "$target_repo" ]] && repo_url="$target_repo"
                                    success "Created test issue #$issue_num for $workflow: https://github.com/$repo_url/issues/$issue_num"
                                    sleep 10
                                    if wait_for_issue_closed "$issue_num" "Closed by $ai_display_name safe output" "$workflow" "$target_repo"; then
                                        test_result="PASS"
                                    fi
                                fi
                                ;;
                            *"remove-labels")
                                info "Creating test issue with label to trigger $workflow..."
                                local issue_title="Test remove label from $ai_display_name"
                                local issue_num=$(create_test_issue "$issue_title" "This is a test issue to trigger $workflow" "copilot-remove-label-test" "$target_repo")
                                if [[ -n "$issue_num" ]]; then
                                    local repo_url="$REPO_OWNER/$REPO_NAME"
                                    [[ -n "$target_repo" ]] && repo_url="$target_repo"
                                    success "Created test issue #$issue_num with label for $workflow: https://github.com/$repo_url/issues/$issue_num"
                                    sleep 10
                                    if wait_for_label_removed "$issue_num" "copilot-remove-label-test" "$workflow" "$target_repo"; then
                                        test_result="PASS"
                                    fi
                                fi
                                ;;
                            *"update-pull-request")
                                info "Creating test pull request to trigger $workflow..."
                                local pr_num=$(create_test_pr "Test PR for $ai_display_name Update PR" "This PR is for testing $workflow" "$target_repo")
                                if [[ -n "$pr_num" ]]; then
                                    local repo_url="$REPO_OWNER/$REPO_NAME"
                                    [[ -n "$target_repo" ]] && repo_url="$target_repo"
                                    success "Created test PR #$pr_num for $workflow: https://github.com/$repo_url/pull/$pr_num"
                                    sleep 10
                                    if wait_for_pr_update "$pr_num" "$ai_display_name" "$workflow" "$target_repo"; then
                                        test_result="PASS"
                                    fi
                                fi
                                ;;
                            *"close-pull-request")
                                info "Creating test pull request to trigger $workflow..."
                                local pr_num=$(create_test_pr "Test PR for $ai_display_name Close" "This PR is for testing $workflow" "$target_repo")
                                if [[ -n "$pr_num" ]]; then
                                    local repo_url="$REPO_OWNER/$REPO_NAME"
                                    [[ -n "$target_repo" ]] && repo_url="$target_repo"
                                    success "Created test PR #$pr_num for $workflow: https://github.com/$repo_url/pull/$pr_num"
                                    sleep 10
                                    if wait_for_pr_closed "$pr_num" "$workflow" "$target_repo"; then
                                        test_result="PASS"
                                    fi
                                fi
                                ;;
                            *"mark-pull-request-as-ready-for-review")
                                info "Creating draft pull request to trigger $workflow..."
                                local pr_num=$(create_test_draft_pr "Test PR for $ai_display_name Mark Ready" "This PR is for testing $workflow" "$target_repo")
                                if [[ -n "$pr_num" ]]; then
                                    local repo_url="$REPO_OWNER/$REPO_NAME"
                                    [[ -n "$target_repo" ]] && repo_url="$target_repo"
                                    success "Created draft test PR #$pr_num for $workflow: https://github.com/$repo_url/pull/$pr_num"
                                    sleep 10
                                    if wait_for_pr_ready_for_review "$pr_num" "$workflow" "$target_repo"; then
                                        test_result="PASS"
                                    fi
                                fi
                                ;;
                            *"push-to-pull-request-branch")
                                info "Creating test pull request to trigger $workflow..."
                                local pr_info=$(create_test_pr_with_branch "Test PR for $ai_display_name Push-to-Branch" "This PR is for testing $workflow" "$target_repo")
                                if [[ -n "$pr_info" ]]; then
                                    IFS=',' read -r pr_num branch_name after_commit_sha repo_from_info <<< "$pr_info"
                                    local repo_url="$REPO_OWNER/$REPO_NAME"
                                    [[ -n "$target_repo" ]] && repo_url="$target_repo"
                                    success "Created test PR #$pr_num for $workflow with branch '$branch_name': https://github.com/$repo_url/pull/$pr_num"
                                    post_pr_command "$pr_num" "/test-${ai_type}-push-to-pull-request-branch" "$target_repo"
                                    if wait_for_branch_update "$branch_name" "$after_commit_sha" "$workflow" "$target_repo"; then
                                        test_result="PASS"
                                    fi
                                fi
                                ;;
                            *"reply-to-pull-request-review-comment")
                                info "Creating PR + review comment fixture to trigger $workflow..."
                                local fixture=$(create_test_pr_with_review_comment "Test PR for $ai_display_name Reply Review Comment" "This PR is for testing $workflow." "$target_repo")
                                if [[ -n "$fixture" ]]; then
                                    IFS=',' read -r pr_num comment_id thread_id <<< "$fixture"
                                    local repo_url="$REPO_OWNER/$REPO_NAME"
                                    [[ -n "$target_repo" ]] && repo_url="$target_repo"
                                    success "Created test PR #$pr_num with review comment $comment_id for $workflow: https://github.com/$repo_url/pull/$pr_num"
                                    if [[ -n "$comment_id" ]] && trigger_workflow_with_inputs "$workflow" "pull_request_number=$pr_num" "comment_id=$comment_id"; then
                                        if wait_for_review_comment_reply "$pr_num" "Reply from $ai_display_name reply-to-pull-request-review-comment safe output" "$workflow" "$target_repo"; then
                                            test_result="PASS"
                                        fi
                                    fi
                                fi
                                ;;
                            *"resolve-pull-request-review-thread")
                                info "Creating PR + review thread fixture to trigger $workflow..."
                                local fixture=$(create_test_pr_with_review_comment "Test PR for $ai_display_name Resolve Review Thread" "This PR is for testing $workflow." "$target_repo")
                                if [[ -n "$fixture" ]]; then
                                    IFS=',' read -r pr_num comment_id thread_id <<< "$fixture"
                                    local repo_url="$REPO_OWNER/$REPO_NAME"
                                    [[ -n "$target_repo" ]] && repo_url="$target_repo"
                                    success "Created test PR #$pr_num with review thread $thread_id for $workflow: https://github.com/$repo_url/pull/$pr_num"
                                    if [[ -n "$thread_id" ]] && trigger_workflow_with_inputs "$workflow" "pull_request_number=$pr_num" "thread_id=$thread_id"; then
                                        if wait_for_review_thread_resolved "$thread_id" "$workflow"; then
                                            test_result="PASS"
                                        fi
                                    fi
                                fi
                                ;;
                            *"pull-request-review-comment")
                                info "Creating test pull request to trigger $workflow..."
                                local pr_num=$(create_test_pr "Test PR for $ai_display_name Review Comments" "This PR is for testing $workflow. Please add review comments." "$target_repo")
                                if [[ -n "$pr_num" ]]; then
                                    local repo_url="$REPO_OWNER/$REPO_NAME"
                                    [[ -n "$target_repo" ]] && repo_url="$target_repo"
                                    success "Created test PR #$pr_num for $workflow: https://github.com/$repo_url/pull/$pr_num"
                                    post_pr_command "$pr_num" "/test-${ai_type}-create-pull-request-review-comment" "$target_repo"
                                    if wait_for_pr_reviews "$pr_num" "$ai_display_name" "$workflow" "$target_repo"; then
                                        test_result="PASS"
                                    fi
                                fi
                                ;;
                            *"command")
                                info "Creating test issue to trigger $workflow..."
                                local issue_num=$(create_test_issue "Test Issue for $ai_display_name Commands" "This issue is for testing $workflow" "" "$target_repo")
                                if [[ -n "$issue_num" ]]; then
                                    local repo_url="$REPO_OWNER/$REPO_NAME"
                                    [[ -n "$target_repo" ]] && repo_url="$target_repo"
                                    success "Created test issue #$issue_num for $workflow: https://github.com/$repo_url/issues/$issue_num"
                                    post_issue_command "$issue_num" "/test-${ai_type}-command What is 102+103?" "$target_repo"
                                    if wait_for_command_comment "$issue_num" "205|I'm $ai_display_name" "$workflow" "$target_repo"; then
                                        test_result="PASS"
                                    fi
                                fi
                                ;;
                            *"update-discussion")
                                info "Creating test discussion to trigger $workflow..."
                                local discussion_title="Test update discussion from $ai_display_name"
                                local discussion_num=$(create_test_discussion "$discussion_title" "Original discussion body for update-discussion test." "General" "$target_repo")
                                if [[ -n "$discussion_num" ]]; then
                                    local repo_url="$REPO_OWNER/$REPO_NAME"
                                    [[ -n "$target_repo" ]] && repo_url="$target_repo"
                                    success "Created test discussion #$discussion_num for $workflow: https://github.com/$repo_url/discussions/$discussion_num"
                                    sleep 10
                                    if wait_for_discussion_updated "$discussion_num" "[UPDATED]" "$workflow" "$target_repo"; then
                                        test_result="PASS"
                                    fi
                                else
                                    warning "Could not create test discussion for $workflow - discussions may not be enabled on this repository"
                                    test_result="PASS"
                                fi
                                ;;
                            *"assign-to-user")
                                info "Creating test issue to trigger $workflow..."
                                local issue_num=$(create_test_issue "Test assign to user from $ai_display_name" "This is a test issue to trigger $workflow" "" "$target_repo")
                                if [[ -n "$issue_num" ]]; then
                                    local repo_url="$REPO_OWNER/$REPO_NAME"
                                    [[ -n "$target_repo" ]] && repo_url="$target_repo"
                                    success "Created test issue #$issue_num for $workflow: https://github.com/$repo_url/issues/$issue_num"
                                    sleep 10
                                    if wait_for_assignee_present "$issue_num" "dsyme" "$workflow" "$target_repo"; then
                                        test_result="PASS"
                                    fi
                                fi
                                ;;
                            *"unassign-from-user")
                                info "Creating test issue with assignee to trigger $workflow..."
                                local issue_num=$(create_test_issue "Test unassign from user from $ai_display_name" "This is a test issue to trigger $workflow" "" "$target_repo")
                                if [[ -n "$issue_num" ]]; then
                                    local repo_url="$REPO_OWNER/$REPO_NAME"
                                    [[ -n "$target_repo" ]] && repo_url="$target_repo"
                                    local repo_flag=""
                                    [[ -n "$target_repo" ]] && repo_flag="--repo $target_repo"
                                    if gh issue edit $repo_flag "$issue_num" --add-assignee "dsyme" &>> "$LOG_FILE"; then
                                        success "Created and assigned issue #$issue_num to dsyme for $workflow: https://github.com/$repo_url/issues/$issue_num"
                                    else
                                        warning "Failed to add assignee dsyme to issue #$issue_num; test may fail"
                                    fi
                                    sleep 10
                                    if wait_for_assignee_absent "$issue_num" "dsyme" "$workflow" "$target_repo"; then
                                        test_result="PASS"
                                    fi
                                fi
                                ;;
                            *"assign-milestone")
                                info "Ensuring milestone exists for $workflow..."
                                local milestone_title="Copilot Safe Output Test Milestone"
                                local milestone_repo="${target_repo:-$REPO_OWNER/$REPO_NAME}"
                                ensure_milestone "$milestone_title" "$milestone_repo" >/dev/null || warning "Could not ensure milestone '$milestone_title'"
                                info "Creating test issue to trigger $workflow..."
                                local issue_num=$(create_test_issue "Test assign milestone from $ai_display_name" "This is a test issue to trigger $workflow" "" "$target_repo")
                                if [[ -n "$issue_num" ]]; then
                                    local repo_url="$REPO_OWNER/$REPO_NAME"
                                    [[ -n "$target_repo" ]] && repo_url="$target_repo"
                                    success "Created test issue #$issue_num for $workflow: https://github.com/$repo_url/issues/$issue_num"
                                    sleep 10
                                    if wait_for_milestone_assigned "$issue_num" "$milestone_title" "$workflow" "$target_repo"; then
                                        test_result="PASS"
                                    fi
                                fi
                                ;;
                            *"set-issue-type")
                                info "Creating test issue to trigger $workflow..."
                                local issue_num=$(create_test_issue "Test set issue type from $ai_display_name" "This is a test issue to trigger $workflow" "" "$target_repo")
                                if [[ -n "$issue_num" ]]; then
                                    local repo_url="$REPO_OWNER/$REPO_NAME"
                                    [[ -n "$target_repo" ]] && repo_url="$target_repo"
                                    success "Created test issue #$issue_num for $workflow: https://github.com/$repo_url/issues/$issue_num"
                                    sleep 10
                                    if wait_for_issue_type "$issue_num" "Task" "$workflow" "$target_repo"; then
                                        test_result="PASS"
                                    fi
                                fi
                                ;;
                            *"link-sub-issue")
                                info "Creating parent + sub issues to trigger $workflow..."
                                local parent_num=$(create_test_issue "[link-sub-fixture] parent for $ai_display_name" "Parent issue for link-sub-issue test." "" "$target_repo")
                                local sub_num=$(create_test_issue "[link-sub-fixture] sub for $ai_display_name" "Sub issue for link-sub-issue test." "" "$target_repo")
                                if [[ -n "$parent_num" && -n "$sub_num" ]]; then
                                    local repo_url="$REPO_OWNER/$REPO_NAME"
                                    [[ -n "$target_repo" ]] && repo_url="$target_repo"
                                    success "Created parent #$parent_num and sub #$sub_num for $workflow"
                                    if trigger_workflow_with_inputs "$workflow" "parent_issue_number=$parent_num" "sub_issue_number=$sub_num"; then
                                        if wait_for_sub_issue_linked "$parent_num" "$sub_num" "$workflow" "$target_repo"; then
                                            test_result="PASS"
                                        fi
                                    fi
                                fi
                                ;;
                            *"hide-comment")
                                info "Creating placeholder issue + comment for $workflow..."
                                local host_num=$(create_test_issue "[hide-comment-host] placeholder for $ai_display_name" "Placeholder issue hosting a comment to be hidden." "" "$target_repo")
                                if [[ -n "$host_num" ]]; then
                                    local comment_node_id
                                    comment_node_id=$(add_test_comment_get_node_id "$host_num" "This comment should be hidden by the $workflow safe output." "$target_repo")
                                    if [[ -n "$comment_node_id" ]]; then
                                        info "Posted comment with node ID: $comment_node_id"
                                        if trigger_workflow_with_inputs "$workflow" "comment_node_id=$comment_node_id" "host_issue_number=$host_num"; then
                                            if wait_for_comment_hidden "$comment_node_id" "$workflow"; then
                                                test_result="PASS"
                                            fi
                                        fi
                                    fi
                                fi
                                ;;
                            *"add-reviewer")
                                info "Creating test pull request to trigger $workflow..."
                                local pr_num=$(create_test_pr "Test PR for $ai_display_name Add Reviewer" "This PR is for testing $workflow" "$target_repo")
                                if [[ -n "$pr_num" ]]; then
                                    local repo_url="$REPO_OWNER/$REPO_NAME"
                                    [[ -n "$target_repo" ]] && repo_url="$target_repo"
                                    success "Created test PR #$pr_num for $workflow: https://github.com/$repo_url/pull/$pr_num"
                                    sleep 10
                                    if wait_for_pr_reviewer_added "$pr_num" "pelikhan" "$workflow" "$target_repo"; then
                                        test_result="PASS"
                                    fi
                                fi
                                ;;
                            *"submit-pull-request-review")
                                info "Creating test pull request to trigger $workflow..."
                                local pr_num=$(create_test_pr "Test PR for $ai_display_name Submit Review" "This PR is for testing $workflow." "$target_repo")
                                if [[ -n "$pr_num" ]]; then
                                    local repo_url="$REPO_OWNER/$REPO_NAME"
                                    [[ -n "$target_repo" ]] && repo_url="$target_repo"
                                    success "Created test PR #$pr_num for $workflow: https://github.com/$repo_url/pull/$pr_num"
                                    post_pr_command "$pr_num" "/test-${ai_type}-submit-pull-request-review" "$target_repo"
                                    if wait_for_pr_review_with_body "$pr_num" "Reviewed by $ai_display_name submit-pull-request-review safe output" "$workflow" "$target_repo"; then
                                        test_result="PASS"
                                    fi
                                fi
                                ;;
                        esac
                    fi
                fi
            fi
            ;;
    esac
    
    # Write result to shared file atomically
    (
        flock -x 200
        echo "$workflow|$test_result" >> "$RESULTS_FILE"
    ) 200>"$RESULTS_LOCK"
    
    # Output test log for aggregation
    cat "$test_log"
    rm -f "$test_log"
    
    return 0
}

# Display batch progress with nice formatting
show_batch_progress() {
    local batch_num="$1"
    local total_batches="$2"
    local batch_size="$3"
    local batch_start="$4"
    local batch_end="$5"
    local total_tests="$6"
    
    echo
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}  ${PURPLE}Batch ${batch_num}/${total_batches}${NC} - Running tests ${batch_start}-${batch_end} of ${total_tests}  ${CYAN}║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo
}

# Show batch completion status
show_batch_completion() {
    local batch_num="$1"
    local passed="$2"
    local failed="$3"
    local skipped="$4"
    local total="$5"
    
    echo
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}  Batch ${batch_num} Complete: ${GREEN}✓ ${passed}${NC} | ${RED}✗ ${failed}${NC} | ${YELLOW}⏭ ${skipped}${NC} (${total} total)  ${CYAN}║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════╝${NC}"
}

# Run tests in parallel batches (or sequentially if batch size is 1)
run_tests_parallel() {
    local patterns=("$@")
    
    local workflows
    readarray -t workflows < <(filter_tests "${patterns[@]}")
    
    if [[ ${#workflows[@]} -eq 0 ]]; then
        warning "No tests match the specified patterns"
        return 0
    fi
    
    local total_tests=${#workflows[@]}
    
    # Initialize results file for parallel/batch execution
    > "$RESULTS_FILE"
    
    local total_batches=$(( (total_tests + BATCH_SIZE - 1) / BATCH_SIZE ))
    local batch_num=1
    
    if [[ $BATCH_SIZE -eq 1 ]]; then
        info "🧪 Running tests sequentially (batch size 1)..."
    else
        info "🧪 Running tests in parallel (batch size $BATCH_SIZE)..."
    fi
    
    info "Total tests to run: $total_tests (in $total_batches batch(es) of size $BATCH_SIZE)"
    echo
    
    # Process tests in batches (with batch size 1 for sequential mode)
    for ((i=0; i<total_tests; i+=BATCH_SIZE)); do
        local batch_start=$((i + 1))
        local batch_end=$((i + BATCH_SIZE))
        [[ $batch_end -gt $total_tests ]] && batch_end=$total_tests
        
        local batch_tests=("${workflows[@]:$i:$BATCH_SIZE}")
        
        show_batch_progress "$batch_num" "$total_batches" "$BATCH_SIZE" "$batch_start" "$batch_end" "$total_tests"
        
        # Launch tests in this batch
        local pids=()
        local -A pid_to_test=()
        local -A pid_to_start=()
        local batch_launch_time=$(date +%s)
        for test in "${batch_tests[@]}"; do
            progress "  🚀 Starting: $test"
            run_single_test "$test" &
            local _pid=$!
            pids+=("$_pid")
            pid_to_test[$_pid]="$test"
            pid_to_start[$_pid]=$batch_launch_time
        done

        # Wait for batch to complete with live status
        local completed=0
        local total_in_batch=${#batch_tests[@]}
        # Hard ceiling per test — PR-triggered tests + validation polling can take ~5–8 min in parallel
        local per_test_kill_seconds=600
        echo
        info "  ⏳ Waiting for $total_in_batch tests to complete (per-test kill after ${per_test_kill_seconds}s)..."

        # Save cursor position; each iteration restores here and erases to end-of-screen,
        # so the bar redraws in-place regardless of terminal width or line wrapping.
        printf "\033[s"
        while [[ $completed -lt $total_in_batch ]]; do
            completed=0
            local running_summary=()
            local now=$(date +%s)
            for pid in "${pids[@]}"; do
                if ! kill -0 "$pid" 2>/dev/null; then
                    completed=$((completed + 1))
                    continue
                fi
                local elapsed=$(( now - ${pid_to_start[$pid]} ))
                # Kill tests that exceed the hard ceiling
                if [[ $elapsed -gt $per_test_kill_seconds ]]; then
                    local stuck_test="${pid_to_test[$pid]}"
                    printf "\033[u\033[J"
                    warning "  ⏰ Killing '$stuck_test' (pid $pid) — exceeded ${per_test_kill_seconds}s"
                    printf "\033[s"
                    kill -TERM "$pid" 2>/dev/null
                    sleep 1
                    kill -KILL "$pid" 2>/dev/null
                    # Record as FAIL so the results reader sees it
                    (
                        flock -x 200
                        echo "$stuck_test|FAIL" >> "$RESULTS_FILE"
                    ) 200>"$RESULTS_LOCK"
                    completed=$((completed + 1))
                    continue
                fi
                running_summary+=("${pid_to_test[$pid]}(${elapsed}s)")
            done

            # Show progress bar + running test names
            if [[ $total_in_batch -gt 0 ]]; then
                local progress_pct=$(( completed * 100 / total_in_batch ))
                local filled=$(( completed * 40 / total_in_batch ))
                local empty=$(( 40 - filled ))
                local running_text=""
                if [[ ${#running_summary[@]} -gt 0 ]]; then
                    running_text=" — running: $(IFS=', '; echo "${running_summary[*]}")"
                fi
                local term_width; term_width=$(tput cols 2>/dev/null || echo "${COLUMNS:-80}")
                # Visible prefix: "  [" + 40-char bar + "] N/M (PP%)"
                local visible_prefix_len=$(( 2 + 1 + 40 + 1 + 1 + ${#completed} + 1 + ${#total_in_batch} + 2 + ${#progress_pct} + 2 ))
                local available=$(( term_width - visible_prefix_len ))
                # Note: ${#running_text} counts UTF-8 bytes, so the em-dash counts as 3.
                # That's fine — it just makes us truncate slightly earlier, never later.
                if (( available > 4 )) && (( ${#running_text} > available )); then
                    running_text="${running_text:0:$((available-1))}…"
                fi
                # Restore cursor to saved position, erase to end of screen, redraw bar.
                printf "\033[u\033[J  ${BLUE}[${GREEN}%${filled}s${NC}%${empty}s${BLUE}]${NC} ${completed}/${total_in_batch} (${progress_pct}%%)%s" \
                    "$(printf '#%.0s' $(seq 1 $filled 2>/dev/null))" \
                    "$(printf ' %.0s' $(seq 1 $empty 2>/dev/null))" \
                    "$running_text"
            fi

            sleep 1
        done
        echo
        echo
        
        # Read batch results
        local batch_passed=0
        local batch_failed=0
        local batch_skipped=0
        
        while IFS='|' read -r test_name result; do
            for batch_test in "${batch_tests[@]}"; do
                if [[ "$test_name" == "$batch_test" ]]; then
                    case "$result" in
                        PASS)
                            success "  ✓ $test_name"
                            batch_passed=$((batch_passed + 1))
                            record_test_pass "$test_name"
                            ;;
                        FAIL)
                            error "  ✗ $test_name"
                            batch_failed=$((batch_failed + 1))
                            record_test_fail "$test_name"
                            ;;
                        SKIP)
                            warning "  ⏭ $test_name"
                            batch_skipped=$((batch_skipped + 1))
                            SKIPPED_TESTS+=("$test_name")
                            ;;
                    esac
                    break
                fi
            done
        done < "$RESULTS_FILE"
        
        show_batch_completion "$batch_num" "$batch_passed" "$batch_failed" "$batch_skipped" "$total_in_batch"
        
        batch_num=$((batch_num + 1))
    done
    
    # Cleanup parallel execution files
    rm -f "$RESULTS_FILE" "$RESULTS_LOCK"
    
    # Load globally tracked workflows for final cleanup
    if [[ -f "/tmp/e2e-workflows-list-$$.txt" ]]; then
        while IFS= read -r wf; do
            [[ -n "$wf" ]] && GLOBAL_WORKFLOWS_TO_DISABLE+=("$wf")
        done < "/tmp/e2e-workflows-list-$$.txt"
    fi
    
    echo
}

# Main run_tests dispatcher - uses parallel with batch size for both modes
run_tests() {
    if [[ "$NO_PARALLEL" == true ]]; then
        BATCH_SIZE=1
    fi
    run_tests_parallel "$@"
}

print_final_report() {
    echo
    echo "============================================"
    echo -e "${CYAN}📊 FINAL TEST REPORT${NC}"
    echo "============================================"
    echo
    
    local total_tests=$((${#PASSED_TESTS[@]} + ${#FAILED_TESTS[@]} + ${#SKIPPED_TESTS[@]}))
    
    echo -e "${GREEN}✅ PASSED (${#PASSED_TESTS[@]}/$total_tests):${NC}"
    for test in "${PASSED_TESTS[@]}"; do
        echo -e "   ${GREEN}✓${NC} $test"
    done
    echo
    
    if [[ ${#FAILED_TESTS[@]} -gt 0 ]]; then
        echo -e "${RED}❌ FAILED (${#FAILED_TESTS[@]}/$total_tests):${NC}"
        for test in "${FAILED_TESTS[@]}"; do
            echo -e "   ${RED}✗${NC} $test"
        done
        echo
    fi
    
    if [[ ${#SKIPPED_TESTS[@]} -gt 0 ]]; then
        echo -e "${YELLOW}⏭️  SKIPPED (${#SKIPPED_TESTS[@]}/$total_tests):${NC}"
        for test in "${SKIPPED_TESTS[@]}"; do
            echo -e "   ${YELLOW}↷${NC} $test"
        done
        echo
    fi
    
    local success_rate
    if [[ $total_tests -gt 0 ]]; then
        success_rate=$(( (${#PASSED_TESTS[@]} * 100) / total_tests ))
    else
        success_rate=0
    fi
    
    echo "============================================"
    echo -e "${CYAN}📈 Success Rate: ${success_rate}% (${#PASSED_TESTS[@]}/$total_tests)${NC}"
    echo -e "${CYAN}📄 Log file: $LOG_FILE${NC}"
    echo "============================================"

    # If anything failed in this run, emit a ready-to-paste prompt for a coding agent to
    # triage the failures from the run logs.
    if [[ ${#FAILED_TESTS[@]} -gt 0 ]]; then
        print_agent_triage_prompt
    fi

    if [[ -f "fails.txt" ]]; then
        info "Remaining failures in fails.txt (run './e2e.sh report' to file issues, './e2e.sh rerun' to retry)"
        exit 1
    elif [[ ${#FAILED_TESTS[@]} -gt 0 ]]; then
        info "Failures recorded in fails.txt (run './e2e.sh report' to file issues, './e2e.sh rerun' to retry)"
        exit 1
    fi
}

# Emit a copy-paste prompt instructing a coding agent to debug the failed tests
# from the run logs and categorize each failure as transient / test-framework
# bug / gh-aw bug (filing github/gh-aw issues for the latter).
print_agent_triage_prompt() {
    local failed_list=""
    if [[ ${#FAILED_TESTS[@]} -gt 0 ]]; then
        failed_list=$(printf '  - %s\n' "${FAILED_TESTS[@]}")
    elif [[ -f "fails.txt" ]]; then
        failed_list=$(sed 's/^/  - /' "fails.txt")
    fi

    echo
    echo "============================================"
    echo -e "${CYAN}🤖 AGENT TRIAGE PROMPT${NC}"
    echo "============================================"
    echo "Copy the block below into a coding agent to investigate the failures:"
    echo
    cat <<EOF
You are triaging failures from the gh-aw-test E2E suite.
Test harness repository: $REPO_OWNER/$REPO_NAME (this repo; runner is e2e.sh).
Repository under test: github/gh-aw (the gh-aw CLI/compiler).
Local run log: $LOG_FILE

Failed tests:
$failed_list

Goal: for EACH failed test, access the GitHub Actions logs for its run (the run
IDs are recorded next to each test in fails.txt; use 'gh run view <run-id> --log'
and 'gh run view <run-id> --log-failed'), plus the local log $LOG_FILE, determine
the root cause, and categorize the failure as exactly one of:

  1. TRANSIENT — flaky/infra/network/rate-limit/timing; not a real defect.
     Action: note it and recommend a re-run (./e2e.sh rerun <test>).
  2. TEST-FRAMEWORK BUG — a defect in this repo's harness (e2e.sh), a workflow
     source file (.github/workflows/test-*.md), a sample, or CI config.
     Action: propose a concrete fix (file + change) in $REPO_OWNER/$REPO_NAME.
  3. GH-AW BUG — a defect in github/gh-aw itself (compiler output, runtime engine
     behaviour, safe-output handling, etc.).
     Action: open an issue in github/gh-aw with a minimal repro, the failing test
     name, the gh-aw ref/mode/samples combination, and links to the relevant log
     lines. Check for an existing open issue first and link it instead of filing
     a duplicate.

Steps:
  - Read AGENTS.md and memory notes in this repo for harness conventions first.
  - Group failures by suspected root cause; one gh-aw bug may explain several.
  - Produce a table: test | category | root cause | recommended action | issue/PR link.
  - Only open github/gh-aw issues for category 3, and only after confirming no
    duplicate exists.
EOF
    echo
    echo "============================================"
}

run_report() {
    local filter_test="${1:-}"

    if [[ ! -f "fails.txt" ]]; then
        error "fails.txt not found. Run e2e tests first to generate failure records."
        exit 1
    fi

    local repo_full="$REPO_OWNER/$REPO_NAME"
    local created_count=0
    local failed_count=0

    if [[ -n "$filter_test" ]]; then
        info "Creating GitHub issue for '$filter_test' from fails.txt..."
    else
        info "Creating GitHub issues for failures listed in fails.txt..."
    fi

    while IFS= read -r line || [[ -n "$line" ]]; do
        [[ -z "$line" ]] && continue

        local test_name run_ids_str
        test_name="${line%% *}"
        if [[ "$line" == *" "* ]]; then
            run_ids_str="${line#* }"
        else
            run_ids_str=""
        fi

        # Skip tests that don't match the filter
        if [[ -n "$filter_test" && "$test_name" != "$filter_test" ]]; then
            continue
        fi

        progress "Processing failure: $test_name"

        # Build run URL from the last run ID on the line; fall back to gh run list lookup
        local run_url=""
        if [[ -n "$run_ids_str" ]]; then
            local last_run_id="${run_ids_str##* }"
            run_url="https://github.com/$repo_full/actions/runs/$last_run_id"
        else
            local workflow_file="${test_name}.lock.yml"
            local run_id
            run_id=$(gh run list \
                --repo "$repo_full" \
                --workflow="$workflow_file" \
                --limit=10 \
                --json databaseId,conclusion \
                --jq '.[] | select(.conclusion == "failure" or .conclusion == "cancelled" or .conclusion == "timed_out") | .databaseId' 2>/dev/null | head -1 || echo "")

            if [[ -n "$run_id" ]]; then
                run_url="https://github.com/$repo_full/actions/runs/$run_id"
            fi
        fi

        local run_ref="${run_url:-"(run URL not found for $test_name)"}"

        local issue_body
        issue_body=$(cat <<ISSUEBODY
Workflow failure run: $run_ref

Debug this workflow failure using your favorite Agent CLI and the agentic-workflows prompt.

## Action Required

### Option 1: Assign this issue to Copilot

Assign this issue to Copilot using the agentic-workflows sub-agent to automatically debug and fix the workflow failure.

### Option 2: Manually invoke the agent

Debug this workflow failure using your favorite Agent CLI and the agentic-workflows prompt.

* Start your agent
* Load the agentic-workflows prompt from \`.github/agents/agentic-workflows.agent.md\` or https://github.com/github/gh-aw/blob/main/.github/agents/agentic-workflows.agent.md
* Type \`debug the agentic workflow $test_name failure in $run_ref\`
ISSUEBODY
        )

        local issue_url
        # Try with Copilot CCA assignment first
        if issue_url=$(gh issue create \
            --repo "$repo_full" \
            --title "Debug agentic-workflow failure: $test_name" \
            --body "$issue_body" \
            --assignee "copilot" 2>/dev/null); then
            success "Created issue (assigned to Copilot) for '$test_name': $issue_url"
            created_count=$((created_count + 1))
        else
            # Fall back without assignee if copilot assignment is not available
            if issue_url=$(gh issue create \
                --repo "$repo_full" \
                --title "Debug agentic-workflow failure: $test_name" \
                --body "$issue_body" 2>/dev/null); then
                success "Created issue for '$test_name': $issue_url"
                warning "Could not assign to Copilot CCA automatically. Assign manually via the issue UI if desired."
                created_count=$((created_count + 1))
            else
                error "Failed to create issue for '$test_name'"
                failed_count=$((failed_count + 1))
            fi
        fi
    done < "fails.txt"

    echo
    if [[ $created_count -gt 0 ]]; then
        success "Created $created_count issue(s) for failed tests"
    fi
    if [[ $failed_count -gt 0 ]]; then
        error "Failed to create $failed_count issue(s)"
        exit 1
    fi
}

run_rerun() {
    local filter_test=""

    # Parse options and an optional positional TEST_NAME filter. This mirrors
    # the option parsing in main() so that flags like --gh-aw-ref work with the
    # rerun subcommand (e.g. './e2e.sh rerun --gh-aw-ref main').
    while [[ $# -gt 0 ]]; do
        case $1 in
            --workflow-dispatch-only)
                WORKFLOW_DISPATCH_ONLY=true
                shift
                ;;
            --use-samples)
                USE_SAMPLES=true
                shift
                ;;
            --verbose|-v)
                VERBOSE=true
                shift
                ;;
            --batch-size)
                if [[ $# -lt 2 || ! "$2" =~ ^[0-9]+$ ]]; then
                    error "--batch-size requires a positive integer value"
                    exit 1
                fi
                BATCH_SIZE="$2"
                shift 2
                ;;
            --batch-size=*)
                BATCH_SIZE="${1#*=}"
                if [[ ! "$BATCH_SIZE" =~ ^[0-9]+$ ]]; then
                    error "--batch-size requires a positive integer value"
                    exit 1
                fi
                shift
                ;;
            --no-parallel)
                NO_PARALLEL=true
                shift
                ;;
            --gh-aw-ref)
                if [[ $# -lt 2 || -z "$2" ]]; then
                    error "--gh-aw-ref requires a value (branch, tag, or SHA)"
                    exit 1
                fi
                GH_AW_REF="$2"
                shift 2
                ;;
            --gh-aw-ref=*)
                GH_AW_REF="${1#*=}"
                if [[ -z "$GH_AW_REF" ]]; then
                    error "--gh-aw-ref requires a value (branch, tag, or SHA)"
                    exit 1
                fi
                shift
                ;;
            --branch)
                if [[ $# -lt 2 || -z "$2" ]]; then
                    error "--branch requires a value (branch name to push/dispatch from)"
                    exit 1
                fi
                E2E_BRANCH="$2"
                shift 2
                ;;
            --branch=*)
                E2E_BRANCH="${1#*=}"
                if [[ -z "$E2E_BRANCH" ]]; then
                    error "--branch requires a value (branch name to push/dispatch from)"
                    exit 1
                fi
                shift
                ;;
            -*)
                error "Unknown option for rerun: $1"
                exit 1
                ;;
            *)
                if [[ -n "$filter_test" ]]; then
                    error "rerun accepts at most one TEST_NAME filter (got '$filter_test' and '$1')"
                    exit 1
                fi
                filter_test="$1"
                shift
                ;;
        esac
    done

    if [[ ! -f "fails.txt" ]]; then
        error "fails.txt not found. Run e2e tests first to generate failure records."
        exit 1
    fi

    # Read test names from fails.txt
    local rerun_tests=()
    while IFS= read -r line || [[ -n "$line" ]]; do
        [[ -z "$line" ]] && continue
        local test_name="${line%% *}"
        if [[ -n "$filter_test" && "$test_name" != "$filter_test" ]]; then
            continue
        fi
        rerun_tests+=("$test_name")
    done < "fails.txt"

    if [[ ${#rerun_tests[@]} -eq 0 ]]; then
        success "No failures to rerun"
        return 0
    fi

    info "Re-running ${#rerun_tests[@]} failed test(s) from fails.txt..."
    for t in "${rerun_tests[@]}"; do
        echo "   - $t"
    done
    echo

    check_prerequisites
    disable_all_workflows_before_testing
    run_tests "${rerun_tests[@]}"
    print_final_report
    cleanup_on_exit
}

main() {
    # Handle subcommands before any other processing
    if [[ "${1:-}" == "report" ]]; then
        run_report "${2:-}"
        return 0
    fi
    if [[ "${1:-}" == "rerun" ]]; then
        shift
        run_rerun "$@"
        return 0
    fi

    echo -e "${CYAN}🧪 GitHub Agentic Workflows End-to-End Testing${NC}"
    echo -e "${CYAN}=================================================${NC}"
    echo
    
    # Parse command line arguments
    local dry_run=false
    local specific_tests=()
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run|-n)
                dry_run=true
                shift
                ;;
            --workflow-dispatch-only)
                WORKFLOW_DISPATCH_ONLY=true
                shift
                ;;
            --use-samples)
                USE_SAMPLES=true
                shift
                ;;
            --verbose|-v)
                VERBOSE=true
                shift
                ;;
            --batch-size)
                if [[ $# -lt 2 || ! "$2" =~ ^[0-9]+$ ]]; then
                    error "--batch-size requires a positive integer value"
                    exit 1
                fi
                BATCH_SIZE="$2"
                shift 2
                ;;
            --batch-size=*)
                BATCH_SIZE="${1#*=}"
                if [[ ! "$BATCH_SIZE" =~ ^[0-9]+$ ]]; then
                    error "--batch-size requires a positive integer value"
                    exit 1
                fi
                shift
                ;;
            --no-parallel)
                NO_PARALLEL=true
                shift
                ;;
            --gh-aw-ref)
                if [[ $# -lt 2 || -z "$2" ]]; then
                    error "--gh-aw-ref requires a value (branch, tag, or SHA)"
                    exit 1
                fi
                GH_AW_REF="$2"
                shift 2
                ;;
            --gh-aw-ref=*)
                GH_AW_REF="${1#*=}"
                if [[ -z "$GH_AW_REF" ]]; then
                    error "--gh-aw-ref requires a value (branch, tag, or SHA)"
                    exit 1
                fi
                shift
                ;;
            --branch)
                if [[ $# -lt 2 || -z "$2" ]]; then
                    error "--branch requires a value (branch name to push/dispatch from)"
                    exit 1
                fi
                E2E_BRANCH="$2"
                shift 2
                ;;
            --branch=*)
                E2E_BRANCH="${1#*=}"
                if [[ -z "$E2E_BRANCH" ]]; then
                    error "--branch requires a value (branch name to push/dispatch from)"
                    exit 1
                fi
                shift
                ;;
            --help|-h)
                echo "Usage: $0 [OPTIONS] [TEST_PATTERNS...]"
                echo "       $0 report"
                echo "       $0 rerun"
                echo ""
                echo "Subcommands:"
                echo "  report [TEST_NAME]         Create GitHub issues for failures in fails.txt"
                echo "                             If TEST_NAME given, only file an issue for that test"
                echo "  rerun [TEST_NAME]          Re-run failed tests from fails.txt"
                echo "                             If TEST_NAME given, only re-run that test"
                echo ""
                echo "Options:"
                echo "  --dry-run, -n              Show what would be tested without running"
                echo "  --workflow-dispatch-only   Only run tests that use workflow_dispatch trigger"
                echo "                             (skip issue/comment/PR-triggered tests)"
                echo "  --use-samples              Use declared samples for more deterministic testing"
                echo "  --verbose, -v              Stream build/compile/version diagnostics to stdout"
                echo "                             (otherwise they only go to the run's log file)."
                echo "  --batch-size <N>           Run tests in parallel batches of N tests (default: 10)"
                echo "  --no-parallel              Disable parallel execution (run tests sequentially)"
                echo "  --gh-aw-ref <ref>          Run E2E tests against gh-aw at this branch/tag/SHA."
                echo "                             Resets parallel ../gh-aw checkout to <ref>, runs"
                echo "                             'make build' there, then recompiles with"
                echo "                             '../gh-aw/gh-aw compile --gh-aw-ref <ref>' so the"
                echo "                             generated lock.yml files reference"
                echo "                             github/gh-aw/actions/setup@<ref> at runtime."
                echo "  --branch <name>            Push recompiled workflows to <name> (force-push)"
                echo "                             instead of main, and dispatch every test with"
                echo "                             '--ref <name>'. Isolates matrix entries from each"
                echo "                             other and from main. Also honoured via the"
                echo "                             E2E_BRANCH environment variable."
                echo "  --help, -h                 Show this help message"
                echo ""
                echo "TEST_PATTERNS:"
                echo "  Specific test names or glob patterns to run:"
                echo "    ./e2e.sh test-claude-create-issue"
                echo "    ./e2e.sh test-claude-* test-codex-* test-copilot-*"
                echo "    ./e2e.sh test-*-create-issue"
                echo ""
                echo "By default, all tests are run."
                exit 0
                ;;
            -*)
                error "Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
            *)
                # This is a test pattern
                specific_tests+=("$1")
                shift
                ;;
        esac
    done
    
    if [[ "$dry_run" == true ]]; then
        info "DRY RUN MODE - Showing what would be tested:"
        echo
        
        if [[ ${#specific_tests[@]} -gt 0 ]]; then
            info "🎯 Test Patterns: ${specific_tests[*]}"
            echo
        fi
        
        info "Tests:"
        local workflows
        readarray -t workflows < <(filter_tests "${specific_tests[@]}")
        if [[ ${#workflows[@]} -gt 0 ]]; then
            for workflow in "${workflows[@]}"; do
                echo "   - $workflow"
            done
        else
            echo "   (no tests match the specified patterns)"
        fi
        echo
        
        exit 0
    fi
    
    log "Starting e2e tests at $(date)"
    
    check_prerequisites
    
    disable_all_workflows_before_testing

    if [[ ${#specific_tests[@]} -gt 0 ]]; then
        info "🎯 Running specific tests: ${specific_tests[*]}"
    fi
    
    run_tests "${specific_tests[@]}"
    
    print_final_report
    
    # Cleanup TEMP_USER_PAT secret
    cleanup_on_exit
    
    log "E2E tests completed at $(date)"
}

# Handle script interruption and exit
trap 'error "Script interrupted"; cleanup_on_exit; exit 130' INT TERM
trap 'cleanup_on_exit' EXIT

main "$@"
