---
on:
  workflow_dispatch:

engine: 
  id: claude

tools:
  cache-memory: true
  edit:
  bash:
    - "echo *"
    - "cat *"
    - "ls *"
    - "mkdir *"
    - "pwd"

safe-outputs:
  create-issue:
    title-prefix: "[file-writing-test] "
    labels: [automation, test]
    min: 1
---

# File Writing Test Workflow

This workflow tests the ability to write files to different locations:

1. **Write to workspace**: Create a file named `workspace-test.txt` in the current workspace directory with content:
   ```
   This file was written to the workspace directory.
   Timestamp: [current timestamp]
   ```

2. **Write to /tmp folder**: Create a file named `tmp-test.txt` in the `/tmp/` directory with content:
   ```
   This file was written to the /tmp directory.
   Timestamp: [current timestamp]
   ```

3. **Write to cache-memory folder**: Create a file named `cache-memory-test.txt` in the `/tmp/cache-memory/` directory with content:
   ```
   This file was written to the cache-memory directory.
   Timestamp: [current timestamp]
   ```

After creating all three files, verify their existence by listing the contents of each directory and reading each file.

Finally, create an issue in repository ${{ github.repository }} with title "File Writing Test Results" and body containing:
- Confirmation that all three files were created successfully
- The actual content of each file
- Directory listings showing the files exist
