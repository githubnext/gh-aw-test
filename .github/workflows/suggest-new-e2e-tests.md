---
emoji: 🔍
description: Daily scan of github/gh-aw activity to identify and propose new E2E test scenarios for githubnext/gh-aw-test
on:
  schedule: daily around 8am UTC
  workflow_dispatch:

permissions:
  issues: read
  pull-requests: read
  actions: read
  contents: read
  copilot-requests: write

steps:
  - name: Fetch recent gh-aw activity and inventory
    env:
      GH_TOKEN: ${{ github.token }}
    run: |
      set -euo pipefail
      mkdir -p /tmp/gh-aw

      # Recently merged PRs in github/gh-aw (last 48 h, up to 40)
      gh pr list --repo github/gh-aw --state merged \
        --json number,title,body,mergedAt,labels \
        --limit 40 \
        > /tmp/gh-aw/recent-prs.json

      # Recently closed issues in github/gh-aw (last 48 h, up to 40)
      gh issue list --repo github/gh-aw --state closed \
        --json number,title,body,closedAt,labels \
        --limit 40 \
        > /tmp/gh-aw/recent-issues.json

      # Existing test source files in githubnext/gh-aw-test
      gh api "repos/githubnext/gh-aw-test/git/trees/main?recursive=1" \
        --jq '[.tree[].path | select(test("^\\.github/workflows/test-[^/]+\\.md$"))]' \
        > /tmp/gh-aw/existing-tests.json

      # Open issues already filed under the triage label (avoid duplicates)
      gh issue list \
        --repo githubnext/gh-aw-test \
        --label "suggested new test" \
        --state open \
        --json number,title \
        --limit 50 \
        > /tmp/gh-aw/open-suggestions.json

      # Current failing tests
      gh api "repos/githubnext/gh-aw-test/contents/fails.txt" \
        --jq '.content' | base64 -d > /tmp/gh-aw/fails.txt 2>/dev/null \
        || echo "" > /tmp/gh-aw/fails.txt

      echo "Prefetch complete."
      echo "PRs:   $(jq length /tmp/gh-aw/recent-prs.json)"
      echo "Issues: $(jq length /tmp/gh-aw/recent-issues.json)"
      echo "Tests: $(jq length /tmp/gh-aw/existing-tests.json)"

tools:
  github:
    mode: gh-proxy
    toolsets: [default]

safe-outputs:
  create-issue:
    labels: ["suggested new test"]
    max: 5
  create-pull-request:
    allowed-files:
      - ".github/workflows/test-*.md"
    max: 2
---

# Suggest New E2E Tests

You are an expert on the `githubnext/gh-aw-test` E2E harness for the `github/gh-aw` CLI extension.

A previous step has already prefetched all the context you need into `/tmp/gh-aw/`. Read those files — do not re-fetch them with `gh` commands.

## Files available

- `/tmp/gh-aw/recent-prs.json` — PRs merged in github/gh-aw (recent, up to 40)
- `/tmp/gh-aw/recent-issues.json` — Issues closed in github/gh-aw (recent, up to 40)
- `/tmp/gh-aw/existing-tests.json` — Current test source files in githubnext/gh-aw-test (array of paths like `.github/workflows/test-copilot-create-issue.md`)
- `/tmp/gh-aw/open-suggestions.json` — Issues already open under the "suggested new test" label
- `/tmp/gh-aw/fails.txt` — Tests currently failing in githubnext/gh-aw-test (one per line)

## What to look for in github/gh-aw activity

Focus on changes that suggest a scenario not yet covered by existing tests:

- **New safe-output types or fields** — e.g. a new `merge-pull-request` or new config options on existing handlers
- **New trigger types or trigger options** — e.g. new `on:` events supported
- **Bug fixes** — especially fixes for edge cases that currently have no regression test
- **New engine-specific behaviours** — features that work differently on Copilot, Claude, or Codex
- **New sandboxing or permission rules** — new network policies, permission scopes, or isolation changes
- **New CLI flags or workflow frontmatter fields** — changes to what the compiler accepts

## Assessment criteria for each candidate scenario

Before proposing a test, verify:

1. **Not already covered** — Check `/tmp/gh-aw/existing-tests.json`. The test naming convention is `test-<engine>-[<variant>-]<feature>.md`. Variants are `nosandbox` and `siderepo`. Infer coverage from names.
2. **Not a duplicate suggestion** — Check `/tmp/gh-aw/open-suggestions.json` for existing open proposals.
3. **Not a failing test** — Check `/tmp/gh-aw/fails.txt`. Do not propose scenarios already represented by a failing test.
4. **Testable via workflow_dispatch** — The E2E harness uses `workflow_dispatch` to trigger tests. The scenario must be exercisable without real human interaction.
5. **Uses existing fixtures** — The existing fixtures are `githubnext/gh-aw-test` (main repo) and `githubnext/gh-aw-side-repo` (side repo for `siderepo` variants). Note explicitly if new fixtures are needed.
6. **Minimal** — A new test should exercise one new capability, not reproduce a large end-to-end scenario.

## Engine selection

- Default to `copilot` as the engine for new tests.
- Only recommend `claude` or `codex` if the change is explicitly engine-specific.
- If a change should eventually be tested across all three engines (e.g. a new core safe-output), note that but propose only the copilot variant for now.

## Writing the issue

For each viable scenario, call `create-issue` with:

**Title**: `Suggested test: <engine>/<feature-name>` (e.g. `Suggested test: copilot/merge-pull-request`)

**Body** (aim for 100–1500 characters):

```
## Motivation

Link to the gh-aw PR or issue: github/gh-aw#<N> — <one-line summary>

## Proposed test

- **Workflow file**: `test-<engine>-<feature>.md`
- **Trigger**: `workflow_dispatch`
- **Engine**: copilot (or note if engine-specific)
- **Safe output**: `<type>` (e.g. `create-issue`, `add-comment`)
- **Variant**: standard / nosandbox / siderepo (choose one; justify if non-standard)

## Minimal test prompt sketch

<1–3 sentences: what the agent should do to exercise the new capability>

## New fixtures or secrets needed

<None> or describe what would be required and why.

## Notes

<Any overlap with existing tests, known edge cases, or open questions.>
```

Create a separate issue for each distinct scenario. Do not combine multiple unrelated scenarios into one issue.

## When to use an issue vs. a PR

Use `create-pull-request` when the scenario is clear-cut and you can write a complete, compilable `.md` source file for it (trigger, frontmatter, prompt body, and a `samples:` block). Restrict changed files to `.github/workflows/test-<engine>-<feature>.md` only — do not include the lock file.

Use `create-issue` when there are open questions about feasibility, required fixtures, secrets, or scope, or when the scenario is speculative. Issues with the "suggested new test" label can be converted to PRs once triaged.

## When to call noop

Call `noop` with a brief explanation if:
- There are no recent changes in `/tmp/gh-aw/recent-prs.json` and `/tmp/gh-aw/recent-issues.json`, or
- All relevant changes are already covered by existing tests or open suggestions.
