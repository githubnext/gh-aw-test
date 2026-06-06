# Parallel Test Execution - Conflict Assessment

## Executive Summary

**RISK LEVEL: MEDIUM-HIGH** for parallel execution of workflow_dispatch tests

Multiple workflow_dispatch tests use **identical or overlapping validation criteria**, creating significant risk of false positives when tests run in parallel. Tests may pass by finding artifacts created by other concurrently running tests.

## Detailed Analysis by Test Type

### 🔴 HIGH RISK: Pull Request Tests

#### Conflicting Tests:
- `test-copilot-create-pull-request`
- `test-copilot-create-two-pull-requests`
- `test-claude-create-pull-request` 
- `test-claude-create-two-pull-requests`
- `test-codex-create-pull-request`
- `test-codex-create-two-pull-requests`
- Plus all nosandbox and siderepo variants

**Problem:**
- All use same title prefix per AI type: `[copilot-test] `, `[claude-test] `, `[codex-test] `
- Validation searches last 10-20 PRs with matching prefix
- `create-pull-request` looks for ANY 1 PR → could find PR from `create-two-pull-requests`
- `create-two-pull-requests` looks for 2+ PRs → could count PR from `create-pull-request`

**Example Conflict:**
```bash
# Parallel batch runs:
test-copilot-create-pull-request       # Creates 1 PR: "[copilot-test] Feature X"
test-copilot-create-two-pull-requests  # Creates 2 PRs: "[copilot-test] Feature A", "[copilot-test] Feature B"

# Validation:
create-pull-request → searches for ANY PR with "[copilot-test]" → finds Feature A → ✅ PASS (correct)
create-two-pull-requests → searches for 2 PRs with "[copilot-test]" → finds Feature A, B, X (3 total) → ✅ PASS (false positive - counted wrong PR!)
```

**Current Validation Logic:**
```bash
# validate_pr_created() - from e2e.sh line 1328
local pr_number=$(gh pr list --limit 10 --json number,title \
  --jq ".[] | select(.title | startswith(\"$title_prefix\")) | .number" | head -1)

# validate_two_prs_created() - from e2e.sh line 1351  
local pr_numbers=$(gh pr list --limit 20 --json number,title \
  --jq ".[] | select(.title | startswith(\"$title_prefix\")) | .number")
local pr_count=$(echo "$pr_numbers" | grep -c '^')
if [[ $pr_count -ge 2 ]]; then
  # PASSES if ANY 2 PRs found with prefix!
```

### 🟡 MEDIUM RISK: Issue Tests

#### Potentially Conflicting Tests:
- `test-copilot-create-issue`
- `test-copilot-mcp` 
- `test-claude-create-issue`
- `test-claude-mcp`
- `test-codex-create-issue`
- `test-codex-mcp`
- Plus nosandbox and siderepo variants

**Problem:**
- `create-issue` tests use prefix `[{ai-type}-test]` and validate with that prefix
- `mcp` tests don't use title prefix (no `title-prefix` in safe-outputs)
- MCP creates issues titled "Hello from {AI}" (without prefix)
- MCP validation searches for content patterns: "MCP time tool", "current time is", "UTC", "time", "Time"

**Partial Mitigation:**
- Issue vs discussion validation queries different resource types (no conflict there)
- `create-issue` validates by prefix, so won't match MCP's non-prefixed issues
- BUT: MCP's broad content search could match `create-issue` issues if they happen to contain time-related words

**Example Conflict:**
```bash
# If workflows add timestamps to issue bodies:
test-copilot-create-issue → Creates "[copilot-test] Hello from Copilot"
                             Body: "Created at 2024-01-15T10:30:00Z"
test-copilot-mcp → Creates "Hello from Copilot" (no prefix)
                   Body: "Current time is 2024-01-15T10:31:00Z"

# Validation:
create-issue → searches prefix "[copilot-test]" → finds own issue → ✅ PASS (correct)
mcp → searches body for "current time is" or "time" → might find create-issue's timestamp → ✅ PASS (false positive!)
```

**Current Validation Logic:**
```bash
# validate_mcp_workflow() - from e2e.sh line 1450
local recent_issues=$(gh issue list --limit 5 --json title,body \
  --jq '.[] | select(.body | contains("MCP time tool") or contains("current time is") or contains("UTC")) | .title' | head -1)

# Fallback check:
local time_issues=$(gh issue list --limit 5 --json title,body \
  --jq '.[] | select(.title or .body | contains("time") or contains("Time") ...) | .title' | head -1)
# This is VERY broad - matches any issue with "time" anywhere!
```

### 🟢 LOW RISK: Discussion Tests

#### Tests:
- `test-copilot-create-discussion`
- `test-claude-create-discussion`
- `test-codex-create-discussion`
- Plus nosandbox and siderepo variants

**Why Low Risk:**
- Discussions are queried separately from issues (different API endpoint)
- Each AI type uses unique prefix: `[copilot-test]`, `[claude-test]`, `[codex-test]`
- No overlapping validation between different AI types

**Note:** Still has same-prefix problem if multiple discussion tests for same AI type existed, but currently only one per AI type.

### 🟢 LOW RISK: Code Scanning Alert Tests

#### Tests:
- `test-copilot-create-repository-code-scanning-alert`
- `test-claude-create-code-scanning-alert`
- `test-codex-create-repository-code-scanning-alert`
- Plus nosandbox variants

**Why Low Risk:**
- Each AI type has unique message: "Copilot wants security review", "Claude wants security review", etc.
- Validation searches for exact AI-specific message in alert
- Different AI types won't cross-validate

**Current Validation Logic:**
```bash
# validate_code_scanning_alert() - from e2e.sh line 1411
# Determines expected message based on workflow name
if [[ "$workflow_name" == *"copilot"* ]]; then
    expected_message="Copilot wants security review."
elif [[ "$workflow_name" == *"claude"* ]]; then
    expected_message="Claude wants security review."
# ...searches for alerts containing that specific message
```

### 🟢 VERY LOW RISK: gh-steps Test

#### Test:
- `test-copilot-gh-steps`

**Why Very Low Risk:**
- Validation includes run ID in expected pattern: `"Test ${expected_run_id}: The number of issues is"`
- Run ID is unique per workflow execution
- Even if other issues exist with similar titles, run ID won't match

**Current Validation Logic:**
```bash
# From e2e.sh line 2865
local run_url="${TEST_RUN_URLS[$workflow]:-}"
local expected_run_id="${run_url##*/}"
# ...
if echo "$issue_title" | grep -q "Test ${expected_run_id}:.*The number of issues is"; then
    success "Issue title contains run ID $expected_run_id and expected gh-steps output: $issue_title"
```

## Recommendations

### 1. 🔴 CRITICAL: Fix PR Test Conflicts

**Option A: Add test-specific suffix to title prefix (RECOMMENDED)**

Modify workflow .md files to use unique prefixes:

```yaml
# test-copilot-create-pull-request.md
safe-outputs:
  create-pull-request:
    title-prefix: "[copilot-test-single-pr] "  # Changed from "[copilot-test] "

# test-copilot-create-two-pull-requests.md
safe-outputs:
  create-pull-request:
    title-prefix: "[copilot-test-two-prs] "    # Changed from "[copilot-test] "
```

Apply to all AI types (claude, codex, copilot) and variants (nosandbox, siderepo).

**Option B: Add run ID to validation (MORE ROBUST)**

Modify validation to only accept PRs created in this specific workflow run:

```bash
validate_pr_created() {
    local title_prefix="$1"
    local expected_run_id="${2:-}"  # Add run ID parameter
    
    if [[ -n "$expected_run_id" ]]; then
        # Search for PR with prefix AND created within last minute from this run
        local pr_number=$(gh pr list --limit 10 --json number,title,createdAt \
          --jq ".[] | select(.title | startswith(\"$title_prefix\")) | \
                select(.createdAt > \"$(date -u -d '1 minute ago' --iso-8601=seconds)\") | .number" | head -1)
    else
        # Fallback to current logic
        # ...
    fi
}
```

### 2. 🟡 IMPORTANT: Fix MCP Test Content Validation

**Problem:** MCP validation searches for generic "time" content which could match unrelated issues.

**Solution:** Make MCP validation more specific:

```bash
validate_mcp_workflow() {
    local workflow_name="$1"
    local repo="${2:-}"
    
    # Search for BOTH title pattern AND MCP-specific content
    local recent_issues=$(gh issue list $repo_flag --limit 5 --json title,body \
      --jq '.[] | select((.title | contains("Hello from")) and 
                        (.body | contains("MCP time tool") or 
                                contains("get_current_time"))) | .title' | head -1)
    
    # Remove overly broad fallback that matches any "time" word
    # Or at least require BOTH "Hello from" title AND time content
}
```

### 3. 🟡 RECOMMENDED: Add Run ID to All Issue Validations

Follow the `gh-steps` pattern for all tests:

```yaml
# In workflow .md files, update prompts to include run ID:
---
Create an issue with title "[copilot-test] Test ${{ github.run_id }}: Hello from Copilot"
---
```

Then validate with:
```bash
validate_issue_created() {
    local title_prefix="$1"
    local expected_run_id="${2:-}"
    
    if [[ -n "$expected_run_id" ]]; then
        local issue_number=$(gh issue list --limit 10 --json number,title \
          --jq ".[] | select(.title | contains(\"${expected_run_id}\")) | \
                      select(.title | startswith(\"$title_prefix\")) | .number" | head -1)
    else
        # Fallback to prefix-only search
    fi
}
```

### 4. 📋 ADD: Validation Report Enhancement

Add post-validation check to warn about potential conflicts:

```bash
# After test completes, count artifacts with same prefix from last 5 minutes
warn_if_multiple_artifacts() {
    local test_type="$1"  # "issue", "pr", "discussion"
    local prefix="$2"
    local recent_count=$(gh $test_type list --limit 20 --json number,title,createdAt \
      --jq ".[] | select(.title | startswith(\"$prefix\")) | \
              select(.createdAt > \"$(date -u -d '5 minutes ago' --iso-8601=seconds)\") | .number" | wc -l)
    
    if [[ $recent_count -gt 1 ]]; then
        warning "Found $recent_count $test_type(s) with prefix '$prefix' from last 5 min - possible test cross-contamination!"
    fi
}
```

## Implementation Priority

1. **IMMEDIATE (before enabling parallel by default):**
   - [ ] Fix PR test conflicts (Option A: unique prefixes)
   - [ ] Fix MCP validation to be more specific

2. **HIGH PRIORITY (for robustness):**
   - [ ] Add run ID to all PR validations (Option B)
   - [ ] Add run ID to issue title patterns

3. **NICE TO HAVE:**
   - [ ] Add validation conflict warnings
   - [ ] Add test-specific tags/markers beyond just prefix

## Testing Strategy

To verify fixes:

```bash
# Test parallel PR creation:
./e2e.sh --batch-size 2 test-copilot-create-pull-request test-copilot-create-two-pull-requests

# Verify:
gh pr list --limit 10 --json number,title,createdAt
# Should see distinct prefixes and both tests should pass correctly
```

## Conclusion

Current validation criteria have **significant overlap risk** in parallel execution, especially for PR tests. The validation logic searches broadly for any matching artifact created recently, without verifying it came from the correct test run.

**Required Actions:**
1. Make PR test prefixes unique per test type
2. Tighten MCP validation criteria
3. Consider adding run IDs to all validation patterns

Without these fixes, parallel execution may produce false positives where tests pass by finding artifacts from other tests.
