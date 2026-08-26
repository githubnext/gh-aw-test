---
on:
  workflow_dispatch:
    inputs:
      issue_number:
        description: "Number of the issue hosting the managed comment-memory comment"
        required: true
        type: string
      memory_note:
        description: "Unique note the agent must append to the comment-memory file"
        required: true
        type: string

permissions:
  contents: read
  issues: read
  copilot-requests: write

engine:
  id: copilot

tools:
  edit:
  # Map-form comment-memory config: memory-id, footer, max and an explicit
  # numeric target (workflow_dispatch has no triggering issue/PR).
  comment-memory:
    max: 1
    memory-id: "e2e-comment-memory"
    target: "${{ github.event.inputs.issue_number }}"
    footer: false

safe-outputs:
  # add-comment gives the harness a deterministic "the run happened" signal and
  # is the sampled path when the suite runs with --use-samples. comment-memory
  # itself is persisted by the post-run file sync, which samples cannot replay.
  add-comment:
    max: 1
    target: "*"
    samples:
      - item_number: "${{ github.event.inputs.issue_number }}"
        body: "Comment memory run finished for note ${{ github.event.inputs.memory_note }}"
---

Comment memory files live in `/tmp/gh-aw/comment-memory/`.

1. Read `/tmp/gh-aw/comment-memory/e2e-comment-memory.md` if it exists. Keep every line that is already in the file — never delete or rewrite existing lines.
2. Append a new line containing exactly `${{ github.event.inputs.memory_note }}` to `/tmp/gh-aw/comment-memory/e2e-comment-memory.md`, creating the file if it does not exist.
3. Use the `add_comment` safe output to post "Comment memory run finished for note ${{ github.event.inputs.memory_note }}" on issue #${{ github.event.inputs.issue_number }}.
