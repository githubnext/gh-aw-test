#!/bin/bash

# Cleanup script for GitHub Agentic Workflows test resources
# This script cleans up test resources (issues, PRs, branches) created during e2e testing
#
# Usage: ./clean.sh
#
# This script will:
# 1. Close all open issues with cleanup comment
# 2. Close all open pull requests with cleanup comment  
# 3. Delete test branches matching specific patterns
# 4. Provide detailed logging of all cleanup operations

set -euo pipefail

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
    local issues_closed=0
    local prs_closed=0
    local branches_deleted=0
        
    # Close all issues
    info "Checking for open issues to close..."
    while read -r issue_num; do
        if [[ -n "$issue_num" ]]; then
            if gh issue close "$issue_num" --comment "Closed by e2e test cleanup" &>/dev/null; then
                info "Closed issue #$issue_num"
                ((issues_closed++))
            else
                warning "Failed to close issue #$issue_num"
            fi
        fi
    done < <(gh issue list --limit 20 --json number --jq '.[].number' 2>/dev/null || true)
    
    # Close all PRs
    info "Checking for open pull requests to close..."
    while read -r pr_num; do
        if [[ -n "$pr_num" ]]; then
            if gh pr close "$pr_num" --comment "Closed by e2e test cleanup" &>/dev/null; then
                info "Closed pull request #$pr_num"
                ((prs_closed++))
            else
                warning "Failed to close pull request #$pr_num"
            fi
        fi
    done < <(gh pr list --limit 20 --json number --jq '.[].number' 2>/dev/null || true)

    # Delete test branches
    info "Checking for test branches to delete..."
    while read -r branch; do
        if [[ -n "$branch" ]]; then
            if git push origin --delete "$branch" &>/dev/null; then
                info "Deleted branch: $branch"
                ((branches_deleted++))
            else
                warning "Failed to delete branch: $branch"
            fi
        fi
    done < <(git branch -r 2>/dev/null | grep 'origin/test-pr-\|origin/claude-test-branch\|origin/codex-test-branch' | sed 's/origin\///' || true)
    
    success "Cleanup completed: $issues_closed issues closed, $prs_closed PRs closed, $branches_deleted branches deleted"
}

main() {
    echo -e "${CYAN}🧹 GitHub Agentic Workflows Test Resource Cleanup${NC}"
    echo -e "${CYAN}==================================================${NC}"
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
}

# Run main function
main "$@"