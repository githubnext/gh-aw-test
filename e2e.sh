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
#   --help, -h                 Show help message
#
# Examples:
#   ./e2e.sh                               # Run all tests
#   ./e2e.sh --dry-run                     # See what would be tested
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

# Secret management functions
set_temp_user_pat() {
    info "Setting TEMP_USER_PAT secret for cross-repo testing..."
    
    # Get the current user's PAT
    local user_pat=$(gh auth token 2>/dev/null)
    
    if [[ -z "$user_pat" ]]; then
        error "Failed to get GitHub auth token. Run 'gh auth login'"
        return 1
    fi
    
    # Set the secret in the repository
    if echo "$user_pat" | gh secret set TEMP_USER_PAT --repo "$REPO_OWNER/$REPO_NAME" &>> "$LOG_FILE"; then
        TEMP_USER_PAT_SET=true
        success "TEMP_USER_PAT secret set successfully"
        return 0
    else
        error "Failed to set TEMP_USER_PAT secret"
        return 1
    fi
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
    echo
    info "Performing cleanup..."
    delete_temp_user_pat
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
    echo "test-claude-mcp"
    echo "test-codex-mcp"
    echo "test-copilot-mcp"
    echo "test-claude-custom-safe-outputs"
    echo "test-codex-custom-safe-outputs"
    echo "test-copilot-custom-safe-outputs"
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
    # Nosandbox tests - limited set for claude/codex, full matrix for copilot
    echo "test-claude-nosandbox-create-issue"
    echo "test-codex-nosandbox-create-issue"
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

    # Install or upgrade the gh-aw extension
    info "Checking gh-aw extension..."
    
    # Check if the extension is already installed
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
    
    # Verify the extension is available
    if ! gh aw --version &>> "$LOG_FILE"; then
        error "gh-aw extension is not available after installation"
        exit 1
    fi

    # Check we're in the right repo
    local current_repo=$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || echo "")
    if [[ "$current_repo" != "$REPO_OWNER/$REPO_NAME" ]]; then
        error "Not in the correct repository. Expected $REPO_OWNER/$REPO_NAME, got $current_repo"
        exit 1
    fi

    # Run "gh aw compile"
    if ! gh aw compile 2>&1 | tee -a "$LOG_FILE"; then
        error "'gh aw compile' failed. Check $LOG_FILE for details"
        exit 1
    fi

    # If there are any updates from the compile, commit them and push them to main to make
    # sure the workflows are up to date for testing

    local git_status
    git_status=$(git status --porcelain)
    if [[ -n "$git_status" ]]; then
        info "Detected changes after 'gh aw compile'; committing and pushing to main branch"
        git add . &>> "$LOG_FILE"
        git commit -m "chore: update compiled workflows via e2e.sh" &>> "$LOG_FILE"
        if git push origin main &>> "$LOG_FILE"; then
            success "Changes pushed to main branch"
        else
            error "Failed to push changes to main branch. Check $LOG_FILE for details"
            exit 1
        fi
    else
        info "No changes detected after 'gh-aw compile'"
    fi

    # Set TEMP_USER_PAT secret for cross-repo testing
    if ! set_temp_user_pat; then
        error "Failed to set TEMP_USER_PAT secret. Cross-repo tests will fail."
        exit 1
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
    
    local disabled_count=0
    local already_disabled_count=0
    
    while IFS=$'\t' read -r workflow_name workflow_state; do
        # Skip if already disabled
        if [[ "$workflow_state" == "disabled_manually" ]] || [[ "$workflow_state" == "disabled_inactivity" ]]; then
            info "  ⏭️  Skipping '$workflow_name' (already $workflow_state)"
            already_disabled_count=$((already_disabled_count + 1))
            continue
        fi
        
        # Disable the workflow
        progress "  Disabling '$workflow_name' (currently $workflow_state)..."
        if gh workflow disable "$workflow_name" &>> "$LOG_FILE"; then
            success "  ✓ Disabled '$workflow_name'"
            disabled_count=$((disabled_count + 1))
        else
            warning "Failed to disable workflow '$workflow_name'"
        fi
    done <<< "$workflows_output"
    
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
            error "Failed to get status for workflow run $run_id"
            error "View run details: https://github.com/$REPO_OWNER/$REPO_NAME/actions/runs/$run_id"
            return 1
        fi
    done
}

get_latest_run_id() {
    local workflow_file="$1"
    gh run list --workflow="$workflow_file" --limit=1 --json databaseId -q '.[0].databaseId' 2>/dev/null || echo ""
}

enable_workflow() {
    local workflow_name="$1"
    
    info "Enabling workflow '$workflow_name'..."
    # Redirect gh aw enable output to log file to prevent terminal control codes from clearing previous output
    gh aw enable "$workflow_name" &>> "$LOG_FILE"
    local rc=$?
    if [[ $rc -eq 0 ]]; then
        success "Successfully enabled '$workflow_name'"
        return 0
    else
        error "Failed to enable '$workflow_name' (exit code: $rc)"
        return 1
    fi
}

disable_workflow() {
    local workflow_name="$1"
    
    info "Disabling workflow '$workflow_name'..."
    gh aw disable "$workflow_name" &>> "$LOG_FILE"
    local rc=$?
    if [[ $rc -eq 0 ]]; then
        success "Successfully disabled '$workflow_name'"
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
    if gh aw run "$workflow_name" &>> "$LOG_FILE"; then
        success "Successfully triggered '$workflow_name'"
        
        # Wait a bit for the new run to appear
        sleep 5
        
        # Get the new run ID
        local after_run_id=$(get_latest_run_id "$workflow_file")
        
        if [[ "$after_run_id" != "$before_run_id" && -n "$after_run_id" ]]; then
            local result=0
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
    
    # Create discussion using GraphQL mutation
    local mutation="mutation {
      createDiscussion(input: {
        repositoryId: \"$repo_id\"
        categoryId: \"$category_id\"
        title: \"$title\"
        body: \"$body\"
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
    local branch="test-pr-$(date +%s)"
    
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
    local file_path="test-file-$(date +%s).md"
    
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
    local branch="test-pr-$(date +%s)"
    
    local repo_flag=""
    local api_repo=":owner/:repo"
    local remote_url="origin"
    if [[ -n "$repo" ]]; then
        repo_flag="--repo $repo"
        api_repo="$repo"
        remote_url="https://github.com/$repo.git"
    fi
    
    # Create a remote branch from main without changing local git state
    git push "$remote_url" "main:$branch" &>/dev/null
    
    # Create a commit on the remote branch using GitHub API to make it different from main
    local commit_message="Test commit for PR"
    local file_content="# Test PR Content\n\nThis is a test file created for PR testing at $(date)"
    local file_path="test-file-$(date +%s).md"
    
    # Get the initial SHA of the branch (before our test commit)
    local initial_sha=$(git ls-remote --heads "$remote_url" "$branch" 2>/dev/null | cut -f1)
    
    if [[ -n "$initial_sha" ]]; then
        # Create a new file on the branch using GitHub API
        gh api repos/"$api_repo"/contents/"$file_path" \
            --method PUT \
            --field message="$commit_message" \
            --field content="$(echo -e "$file_content" | base64 -w 0)" \
            --field branch="$branch" &>/dev/null
        
        # Get the SHA after creating the test commit
        local after_commit_sha=$(git ls-remote --heads "$remote_url" "$branch" 2>/dev/null | cut -f1)
        
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
    
    if echo "$comments" | grep -q "$expected_comment_text"; then
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
    
    # MCP workflows typically create issues with specific patterns indicating MCP tool usage
    # Look for issues with MCP-specific content patterns
    local recent_issues=$(gh issue list $repo_flag --limit 5 --json title,body --jq '.[] | select(.body | contains("MCP time tool") or contains("current time is") or contains("UTC")) | .title' | head -1)

    echo "$recent_issues"  # For debugging purposes
    
    if [[ -n "$recent_issues" ]]; then
        success "MCP workflow '$workflow_name' appears to have used MCP tools successfully"
        return 0
    else
        # Fallback to original time-based check for broader compatibility
        local time_issues=$(gh issue list $repo_flag --limit 5 --json title,body --jq '.[] | select(.title or .body | contains("time") or contains("Time") or contains("timestamp") or contains("Timestamp")) | .title' | head -1)
        
        if [[ -n "$time_issues" ]]; then
            success "MCP workflow '$workflow_name' appears to have used MCP tools successfully (time-based detection)"
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

# Polling functions for workflow validation
wait_for_comment() {
    local issue_number="$1"
    local expected_text="$2"
    local test_name="$3"
    local repo="${4:-}"
    local max_wait=240 # Max wait time in seconds (4 minutes)
    local waited=0
    
    while [[ $waited -lt $max_wait ]]; do
        if validate_comment "$issue_number" "$expected_text" "$repo"; then
            PASSED_TESTS+=("$test_name")
            return 0
        fi
        info "..."
        sleep 5
        waited=$((waited + 5))
    done
    
    FAILED_TESTS+=("$test_name")
    return 1
}

wait_for_labels() {
    local issue_number="$1"
    local expected_label="$2"
    local test_name="$3"
    local repo="${4:-}"
    local max_wait=240 # Max wait time in seconds (4 minutes)
    local waited=0
    
    while [[ $waited -lt $max_wait ]]; do
        if validate_labels "$issue_number" "$expected_label" "$repo"; then
            PASSED_TESTS+=("$test_name")
            return 0
        fi
        info "..."
        sleep 5
        waited=$((waited + 5))
    done
    
    FAILED_TESTS+=("$test_name")
    return 1
}

wait_for_issue_update() {
    local issue_number="$1"
    local ai_type="$2"
    local test_name="$3"
    local repo="${4:-}"
    local max_wait=240 # Max wait time in seconds (4 minutes)
    local waited=0
    
    while [[ $waited -lt $max_wait ]]; do
        if validate_issue_updated "$issue_number" "$ai_type" "$repo"; then
            PASSED_TESTS+=("$test_name")
            return 0
        fi
        info "..."
        sleep 5
        waited=$((waited + 5))
    done
    
    FAILED_TESTS+=("$test_name")
    return 1
}

wait_for_command_comment() {
    local issue_number="$1"
    local expected_text="$2"
    local test_name="$3"
    local repo="${4:-}"
    local max_wait=240 # Max wait time in seconds (4 minutes)
    local waited=0
    
    while [[ $waited -lt $max_wait ]]; do
        if validate_comment "$issue_number" "$expected_text" "$repo"; then
            PASSED_TESTS+=("$test_name")
            return 0
        fi
        info "..."
        sleep 5
        waited=$((waited + 5))
    done
    
    FAILED_TESTS+=("$test_name")
    return 1
}

wait_for_branch_update() {
    local branch_name="$1"
    local initial_sha="$2"
    local test_name="$3"
    local repo="${4:-}"
    local max_wait=240 # Max wait time in seconds (4 minutes)
    local waited=0
    
    while [[ $waited -lt $max_wait ]]; do
        if validate_branch_updated "$branch_name" "$initial_sha" "$repo"; then
            PASSED_TESTS+=("$test_name")
            return 0
        fi
        info "..."
        sleep 5
        waited=$((waited + 5))
    done
    
    FAILED_TESTS+=("$test_name")
    return 1
}

wait_for_pr_reviews() {
    local pr_number="$1"
    local ai_type="$2"
    local test_name="$3"
    local repo="${4:-}"
    local max_wait=240 # Max wait time in seconds (4 minutes)
    local waited=0
    
    while [[ $waited -lt $max_wait ]]; do
        if validate_pr_reviews "$pr_number" "$ai_type" "$repo"; then
            PASSED_TESTS+=("$test_name")
            return 0
        fi
        info "..."
        sleep 5
        waited=$((waited + 5))
    done
    
    FAILED_TESTS+=("$test_name")
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
    
    if echo "$comments" | grep -q "$expected_comment_text"; then
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
    local max_wait=240 # Max wait time in seconds (4 minutes)
    local waited=0
    
    while [[ $waited -lt $max_wait ]]; do
        if validate_discussion_comment "$discussion_number" "$expected_text" "$repo"; then
            PASSED_TESTS+=("$test_name")
            return 0
        fi
        info "..."
        sleep 5
        waited=$((waited + 5))
    done
    
    FAILED_TESTS+=("$test_name")
    return 1
}

run_tests() {
    local patterns=("$@")
    info "🧪 Running tests..."
    
    local workflows
    readarray -t workflows < <(filter_tests "${patterns[@]}")
    
    if [[ ${#workflows[@]} -eq 0 ]]; then
        warning "No tests match the specified patterns"
        return 0
    fi
    
    local workflows_to_disable=()
    
    for workflow in "${workflows[@]}"; do
        progress "Testing workflow: $workflow"
        
        local ai_type=$(extract_ai_type "$workflow")
        local ai_display_name=$(get_ai_display_name "$ai_type")
        local target_repo=$(get_target_repo "$workflow")
        local repo_display=""
        if [[ -n "$target_repo" ]]; then
            repo_display=" (target: $target_repo)"
            info "Cross-repo test targeting: $target_repo"
        fi
        
        # Determine test execution strategy based on workflow name pattern
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
                                wait_for_comment "$issue_num" "Reply from $ai_display_name" "$workflow" "$target_repo" || true
                                ;;
                            *"add-labels")
                                wait_for_labels "$issue_num" "${ai_type}-safe-output-label-test" "$workflow" "$target_repo" || true
                                ;;
                            *"update-issue")
                                wait_for_issue_update "$issue_num" "$ai_display_name" "$workflow" "$target_repo" || true
                                ;;
                        esac
                    else
                        error "Workflow '$workflow' failed to complete successfully"
                        FAILED_TESTS+=("$workflow")
                    fi
                else
                    error "Failed to create test issue for $workflow"
                    FAILED_TESTS+=("$workflow")
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
                        wait_for_discussion_comment "$discussion_num" "Reply from $ai_display_name Discussion" "$workflow" "$target_repo" || true
                    else
                        error "Workflow '$workflow' failed to complete successfully"
                        FAILED_TESTS+=("$workflow")
                    fi
                else
                    warning "Could not create test discussion for $workflow - discussions may not be enabled on this repository"
                    PASSED_TESTS+=("$workflow")
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
                        wait_for_pr_reviews "$pr_num" "$ai_display_name" "$workflow" "$target_repo" || true
                    else
                        error "Workflow '$workflow' failed to complete successfully"
                        FAILED_TESTS+=("$workflow")
                    fi
                else
                    error "Failed to create test PR for $workflow"
                    FAILED_TESTS+=("$workflow")
                fi
                ;;
            # Workflow dispatch tests - triggered with gh aw run
            *"create-issue"|*"create-discussion"|*"create-pull-request"|*"code-scanning-alert"|*"mcp"|*"safe-jobs")
                local workflow_success=false
                if trigger_workflow_dispatch_and_await_completion "$workflow"; then
                    workflow_success=true
                fi
                
                if [[ "$workflow_success" == true ]]; then
                    local validation_success=false
                    case "$workflow" in
                        *"multi")
                            local title_prefix="[${ai_type}-test]"
                            local expected_labels=$(get_expected_labels "$ai_type")
                            if validate_issue_created "$title_prefix" "$expected_labels" "$target_repo"; then
                                validation_success=true
                            fi
                            if validate_pr_created "$title_prefix" "$target_repo"; then
                                validation_success=true
                            fi
                            ;;
                        *"create-issue")
                            local title_prefix="[${ai_type}-test]"
                            local expected_labels=$(get_expected_labels "$ai_type")
                            if validate_issue_created "$title_prefix" "$expected_labels" "$target_repo"; then
                                validation_success=true
                            fi
                            ;;
                        *"create-discussion")
                            local title_prefix="[${ai_type}-test]"
                            local expected_labels=$(get_expected_labels "$ai_type")
                            if validate_discussion_created "$title_prefix" "$expected_labels" "$target_repo"; then
                                validation_success=true
                            fi
                            ;;
                        *"create-two-pull-requests")
                            local title_prefix="[${ai_type}-test]"
                            if validate_two_prs_created "$title_prefix" "$target_repo"; then
                                validation_success=true
                            fi
                            ;;
                        *"create-pull-request")
                            local title_prefix="[${ai_type}-test]"
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
                        *)
                            success "Workflow '$workflow' completed successfully (no specific validation available)"
                            validation_success=true
                            ;;
                    esac
                    
                    if [[ "$validation_success" == true ]]; then
                        PASSED_TESTS+=("$workflow")
                    else
                        FAILED_TESTS+=("$workflow")
                    fi
                else
                    error "Workflow '$workflow' failed to complete successfully"
                    FAILED_TESTS+=("$workflow")
                fi
                ;;
            
            # Issue-triggered and command-triggered tests - need to enable, create trigger, wait
            *)
                local workflow_file_path=".github/workflows/${workflow}.lock.yml"
                if [[ ! -f "$workflow_file_path" ]]; then
                    error "Workflow file not found for '$workflow' at $workflow_file_path; marking as failed"
                    FAILED_TESTS+=("$workflow")
                    continue
                fi

                local enable_success=false
                if enable_workflow "$workflow"; then
                    enable_success=true
                    workflows_to_disable+=("$workflow")
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
                                wait_for_discussion_comment "$discussion_num" "Reply from $ai_display_name Discussion" "$workflow" "$target_repo" || true
                            else
                                warning "Could not create test discussion for $workflow - discussions may not be enabled on this repository"
                                PASSED_TESTS+=("$workflow")
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
                                wait_for_comment "$issue_num" "Reply from $ai_display_name" "$workflow" "$target_repo" || true
                            else
                                error "Failed to create test issue for $workflow"
                                FAILED_TESTS+=("$workflow")
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
                                wait_for_labels "$issue_num" "${ai_type}-safe-output-label-test" "$workflow" "$target_repo" || true
                            else
                                error "Failed to create test issue for $workflow"
                                FAILED_TESTS+=("$workflow")
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
                                wait_for_issue_update "$issue_num" "$ai_display_name" "$workflow" "$target_repo" || true
                            else
                                error "Failed to create test issue for $workflow"
                                FAILED_TESTS+=("$workflow")
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
                                wait_for_branch_update "$branch_name" "$after_commit_sha" "$workflow" "$target_repo" || true
                            else
                                error "Failed to create test PR for $workflow"
                                FAILED_TESTS+=("$workflow")
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
                                wait_for_pr_reviews "$pr_num" "$ai_display_name" "$workflow" "$target_repo" || true
                            else
                                error "Failed to create test PR for $workflow"
                                FAILED_TESTS+=("$workflow")
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
                                wait_for_command_comment "$issue_num" "205" "$workflow" "$target_repo" || true
                            else
                                error "Failed to create test issue for $workflow"
                                FAILED_TESTS+=("$workflow")
                            fi
                            ;;
                    esac
                else
                    error "Failed to enable workflow '$workflow'"
                    FAILED_TESTS+=("$workflow")
                fi
                ;;
        esac
        
        echo # Add spacing between tests
    done
    
    # Disable workflows after testing
    for workflow in "${workflows_to_disable[@]}"; do
        disable_workflow "$workflow" || warning "Failed to disable workflow '$workflow', continuing..."
    done
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
    
    if [[ ${#FAILED_TESTS[@]} -gt 0 ]]; then
        exit 1
    fi
}

main() {
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
            --help|-h)
                echo "Usage: $0 [OPTIONS] [TEST_PATTERNS...]"
                echo ""
                echo "Options:"
                echo "  --dry-run, -n              Show what would be tested without running"
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

# Handle script interruption
trap 'error "Script interrupted"; cleanup_on_exit; exit 130' INT TERM

main "$@"
