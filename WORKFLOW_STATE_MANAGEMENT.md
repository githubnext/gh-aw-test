# Workflow State Management in e2e.sh

## Overview
This document describes how workflows are enabled/disabled during e2e testing to ensure they remain disabled by default and are only enabled when needed.

## Key Principles

1. **Disabled by Default**: All workflows start disabled before testing begins
2. **Enable Only When Needed**: Workflows are enabled only immediately before being tested
3. **Automatic Cleanup**: Workflows are automatically disabled after tests complete or if the script exits early

## Implementation

### 1. Initial State (`disable_all_workflows_before_testing()`)
- Called at the start of every test run (main and rerun modes)
- Disables ALL workflows that aren't already disabled
- Skips workflows already in `disabled_manually` or `disabled_inactivity` state
- Reports count of newly disabled vs already disabled workflows

### 2. Test Execution Patterns

#### Workflow Dispatch Tests
These tests are triggered via `gh workflow run` or `gh aw run`:
- **Function**: `trigger_workflow_dispatch_and_await_completion()` or `trigger_workflow_with_inputs()`
- **Pattern**: 
  1. Enable workflow
  2. Trigger workflow run
  3. Wait for completion
  4. **Disable workflow immediately**
- **Tracking**: Uses `track_globally=true` parameter to add to global cleanup list as fallback

#### Issue/Comment/PR-Triggered Tests
These tests are triggered by creating GitHub resources (issues, PRs, discussions):
- **Pattern**:
  1. Enable workflow
  2. Add to `workflows_to_disable[]` array
  3. Create trigger resource (issue, PR, etc.)
  4. Wait for workflow to complete
  5. Continue to next test
  6. At end of all tests: disable all workflows in `workflows_to_disable[]`

#### Special Case: dispatch-workflow Test
- Enables both dispatcher and worker workflows
- Worker workflow stays enabled throughout the test (added to `workflows_to_disable[]`)
- Dispatcher workflow is enabled/disabled immediately by `trigger_workflow_with_inputs()`

### 3. Global Tracking System

**Purpose**: Ensure workflows are disabled even if script exits early

**Components**:
- `GLOBAL_WORKFLOWS_TO_DISABLE[]` - Array tracking all enabled workflows
- `/tmp/e2e-workflows-list-$$.txt` - Persistent file for parallel processes
- `$GLOBAL_WORKFLOWS_LOCK` - Lock file for synchronized access

**When workflows are added**:
- When `enable_workflow()` is called (unless `track_globally=false`)
- Writes to both array and temp file for persistence

**When workflows are removed**:
- When `disable_workflow()` is called successfully
- Removed from temp file to prevent duplicate cleanup

### 4. Cleanup on Exit

**Trap Handlers**:
```bash
trap 'error "Script interrupted"; cleanup_on_exit; exit 130' INT TERM
trap 'cleanup_on_exit' EXIT
```

**`cleanup_on_exit()` function**:
1. Prevents double execution with `CLEANUP_DONE` flag
2. Loads workflows from temp file (for parallel processes)
3. Removes duplicates from global tracking list
4. Disables all tracked workflows
5. Deletes TEMP_USER_PAT secret (if in local mode)
6. Cleans up temporary files

### 5. Parallel vs Sequential Mode

#### Sequential Mode (`run_tests_sequential()`)
- Maintains local `workflows_to_disable[]` array
- Disables all workflows in array at end of test loop
- Also adds to `GLOBAL_WORKFLOWS_TO_DISABLE[]` for trap handler

#### Parallel Mode (`run_tests_parallel()`)
- Each test runs in subprocess via `run_single_test()`
- Workflows are tracked globally via temp file
- Cleanup happens at end of batch processing
- Global trap handler ensures cleanup on early exit

## Testing the Logic

### Verify workflows start disabled:
```bash
gh workflow list --all | grep -v "disabled"
```

### Verify workflows are enabled during test:
```bash
# In another terminal during test execution:
gh workflow list --all | grep "active"
```

### Verify workflows are disabled after test:
```bash
# After test completes:
gh workflow list --all | grep -v "disabled"
```

### Test early exit cleanup:
```bash
# Start a test and interrupt with Ctrl+C
./e2e.sh test-copilot-create-issue
# Press Ctrl+C during execution
# Verify cleanup runs and workflows are disabled
```

## Benefits

1. **Safe by Default**: Workflows stay disabled when not being tested
2. **No Leakage**: Interrupted tests don't leave workflows enabled
3. **Parallel Safe**: Lock files prevent race conditions in parallel mode
4. **Resilient**: Multiple layers of cleanup (immediate, end-of-test, exit trap)
5. **Visible**: Clear logging of enable/disable operations

## Potential Issues & Mitigations

### Issue: Parallel processes might disable each other's workflows
**Mitigation**: Each workflow is only enabled for its specific test, and disable operations are idempotent

### Issue: Exit trap might run multiple times
**Mitigation**: `CLEANUP_DONE` flag prevents double execution

### Issue: Temp files might persist across runs
**Mitigation**: Uses process ID (`$$`) in filenames for uniqueness

### Issue: Lock file might block forever if process crashes
**Mitigation**: `flock` automatically releases locks when process exits
