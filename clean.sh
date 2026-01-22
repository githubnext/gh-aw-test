#!/bin/bash

# Cleanup script for GitHub Agentic Workflows test resources
# This script cleans up test resources (issues, PRs, branches) created during e2e testing
#
# Usage: ./clean.sh [--dry-run]
#
# Options:
#   --dry-run    Preview what would be deleted without making changes
#
# This script will:
# 1. Close all open issues with cleanup comment
# 2. Close all open pull requests with cleanup comment
# 3. Close all open discussions
# 4. Delete test branches matching specific patterns
# 5. Provide detailed logging of all cleanup operations

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
LOG_FILE="cleanup-$(date +%Y%m%d-%H%M%S).log"
DRY_RUN=false

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

cleanup_test_resources() {
    info "Cleaning up test resources..."
    if [[ "$DRY_RUN" == "true" ]]; then
        warning "DRY RUN MODE - No changes will be made"
    fi
    local issues_closed=0
    local prs_closed=0
    local discussions_closed=0
    local branches_deleted=0
        
    # Close all issues
    info "Checking for open issues to close..."
    while read -r issue_num; do
        if [[ -n "$issue_num" ]]; then
            if [[ "$DRY_RUN" == "true" ]]; then
                info "[DRY RUN] Would close issue #$issue_num"
                ((issues_closed++))
            else
                if gh issue close "$issue_num" --comment "Closed by e2e test cleanup" &>/dev/null; then
                    info "Closed issue #$issue_num"
                    ((issues_closed++))
                else
                    warning "Failed to close issue #$issue_num"
                fi
            fi
        fi
    done < <(gh issue list --limit 20 --json number --jq '.[].number' 2>/dev/null || true)
    
    # Close all PRs
    info "Checking for open pull requests to close..."
    while read -r pr_num; do
        if [[ -n "$pr_num" ]]; then
            if [[ "$DRY_RUN" == "true" ]]; then
                info "[DRY RUN] Would close pull request #$pr_num"
                ((prs_closed++))
            else
                if gh pr close "$pr_num" --comment "Closed by e2e test cleanup" &>/dev/null; then
                    info "Closed pull request #$pr_num"
                    ((prs_closed++))
                else
                    warning "Failed to close pull request #$pr_num"
                fi
            fi
        fi
    done < <(gh pr list --limit 20 --json number --jq '.[].number' 2>/dev/null || true)

    # Close all discussions
    info "Checking for open discussions to close..."
    local discussion_count=0
    
    # Debug: First check if discussions endpoint works
    info "Fetching discussions from API..."
    local api_response=$(gh api repos/:owner/:repo/discussions --paginate 2>&1)
    local api_exit_code=$?
    
    if [[ $api_exit_code -ne 0 ]]; then
        warning "API call failed with exit code $api_exit_code"
        echo "API response: $api_response" >> "$LOG_FILE"
    else
        info "API call succeeded, processing discussions..."
        echo "API response: $api_response" >> "$LOG_FILE"
    fi
    
    # Process each discussion JSON object directly from the API
    # Note: GitHub API uses "state" field with values "open" or "closed", not a boolean "closed" field
    # Note: GraphQL mutations require node_id (global ID), not the numeric id
    while IFS= read -r discussion_line; do
        if [[ -n "$discussion_line" && "$discussion_line" != "null" ]]; then
            local discussion_node_id=$(echo "$discussion_line" | jq -r '.node_id // empty' 2>/dev/null)
            local discussion_num=$(echo "$discussion_line" | jq -r '.number // empty' 2>/dev/null)
            local discussion_title=$(echo "$discussion_line" | jq -r '.title // empty' 2>/dev/null)
            local discussion_state=$(echo "$discussion_line" | jq -r '.state // empty' 2>/dev/null)
            
            info "Processing discussion: NODE_ID=$discussion_node_id, NUM=$discussion_num, STATE=$discussion_state, TITLE=$discussion_title"
            
            if [[ -n "$discussion_node_id" && "$discussion_node_id" != "null" && "$discussion_state" == "open" ]]; then
                ((discussion_count++))
                info "Found open discussion #$discussion_num: $discussion_title (NODE_ID: $discussion_node_id)"
                
                if [[ "$DRY_RUN" == "true" ]]; then
                    info "[DRY RUN] Would close discussion #$discussion_num (NODE_ID: $discussion_node_id)"
                    ((discussions_closed++))
                else
                    # Close discussion using GraphQL mutation (requires node_id, not numeric id)
                    local mutation='mutation {
                      closeDiscussion(input: {discussionId: "'$discussion_node_id'"}) {
                        discussion {
                          number
                        }
                      }
                    }'
                    local result=$(gh api graphql -f query="$mutation" 2>&1)
                    echo "$result" >> "$LOG_FILE"
                    
                    if echo "$result" | grep -q '"number"'; then
                        success "Closed discussion #$discussion_num (NODE_ID: $discussion_node_id)"
                        ((discussions_closed++))
                    else
                        warning "Failed to close discussion #$discussion_num (NODE_ID: $discussion_node_id)"
                        echo "$result" | tee -a "$LOG_FILE"
                    fi
                fi
            fi
        fi
    done < <(echo "$api_response" | jq -c '.[] | {node_id, number, title, state}' 2>/dev/null || true)
    
    if [[ $discussion_count -eq 0 ]]; then
        info "No open discussions found to close"
    fi

    # Delete test branches
    info "Checking for test branches to delete..."
    while read -r branch; do
        if [[ -n "$branch" ]]; then
            if [[ "$DRY_RUN" == "true" ]]; then
                info "[DRY RUN] Would delete branch: $branch"
                ((branches_deleted++))
            else
                if git push origin --delete "$branch" &>/dev/null; then
                    info "Deleted branch: $branch"
                    ((branches_deleted++))
                else
                    warning "Failed to delete branch: $branch"
                fi
            fi
        fi
    done < <(git branch -r 2>/dev/null | grep 'origin/test-pr-\|origin/claude-test-branch\|origin/codex-test-branch' | sed 's/origin\///' || true)
    
    if [[ "$DRY_RUN" == "true" ]]; then
        success "[DRY RUN] Would cleanup: $issues_closed issues, $prs_closed PRs, $discussions_closed discussions, $branches_deleted branches"
    else
        success "Cleanup completed: $issues_closed issues closed, $prs_closed PRs closed, $discussions_closed discussions closed, $branches_deleted branches deleted"
    fi
}

main() {
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            *)
                error "Unknown option: $1"
                echo "Usage: $0 [--dry-run]"
                exit 1
                ;;
        esac
    done
    
    echo -e "${CYAN}🧹 GitHub Agentic Workflows Test Resource Cleanup${NC}"
    echo -e "${CYAN}==================================================${NC}"
    if [[ "$DRY_RUN" == "true" ]]; then
        echo -e "${YELLOW}🔍 DRY RUN MODE - No changes will be made${NC}"
    fi
    echo
    
    log "Starting cleanup at $(date)"

    # Remove build artifacts (source staging dir & compiled binaries) before doing anything else
    # Assumptions:
    # - The working directory is the repo root
    # - The compiled binary is named 'gh-aw' at repo root (and potentially under gh-aw-src during dev)
    # - The user wants gh-aw-src fully removed (will be recreated by future build steps)
    if [[ -d ./gh-aw-src ]]; then
        info "Removing ./gh-aw-src directory"
        rm -rf ./gh-aw-src || warning "Failed to remove ./gh-aw-src"
    else
        info "No ./gh-aw-src directory to remove"
    fi

    for bin in ./gh-aw ./gh-aw-src/gh-aw; do
        if [[ -f "$bin" || -L "$bin" ]]; then
            info "Removing compiled binary $bin"
            rm -f "$bin" || warning "Failed to remove $bin"
        fi
    done

    # Remove e2e test log files
    if compgen -G "e2e-test-*.log" > /dev/null; then
        info "Removing e2e test log files"
        for logf in e2e-test-*.log; do
            info "Deleting $logf"
            rm -f "$logf" || warning "Failed to delete $logf"
        done
    else
        info "No e2e test log files to remove"
    fi

    # Remove old cleanup logs (but keep the current run's log)
    if compgen -G "cleanup-*" > /dev/null; then
        info "Removing old cleanup log files"
        for clog in cleanup-*; do
            if [[ "$clog" == "$LOG_FILE" ]]; then
                continue
            fi
            info "Deleting $clog"
            rm -f "$clog" || warning "Failed to delete $clog"
        done
    else
        info "No prior cleanup-* log files to remove"
    fi
    
    # Check if gh CLI is available and authenticated
    if ! command -v gh &> /dev/null; then
        error "GitHub CLI (gh) is not installed"
        exit 1
    fi
    
    if ! gh auth status &> /dev/null; then
        error "GitHub CLI is not authenticated. Run 'gh auth login'"
        exit 1
    fi
    
    cleanup_test_resources
    
    echo
    echo -e "${CYAN}📄 Log file: $LOG_FILE${NC}"
    exit 0
}

# Run main function
main "$@"