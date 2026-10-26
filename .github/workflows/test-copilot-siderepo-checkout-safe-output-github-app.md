---
on:
  workflow_dispatch:
    inputs:
      branch_name:
        description: Side-repository PR branch
        required: true
        type: string
      pull_request_number:
        description: Side-repository pull request
        required: true
        type: number
permissions:
  contents: read
  pull-requests: read
  copilot-requests: write
engine:
  id: copilot
checkout:
  - repository: githubnext/gh-aw-side-repo
    path: gh-aw-side-repo
    github-app:
      client-id: ${{ vars.GH_AW_TEST_APP_CLIENT_ID }}
      private-key: ${{ secrets.GH_AW_TEST_APP_PRIVATE_KEY }}
      owner: githubnext
      repositories: [gh-aw-side-repo]
    safe-outputs-github-app:
      client-id: ${{ vars.GH_AW_TEST_APP_CLIENT_ID }}
      private-key: ${{ secrets.GH_AW_TEST_APP_PRIVATE_KEY }}
      owner: githubnext
      repositories: [gh-aw-side-repo]
    current: true
safe-outputs:
  push-to-pull-request-branch:
    branch: ${{ inputs.branch_name }}
    target: ${{ inputs.pull_request_number }}
    target-repo: githubnext/gh-aw-side-repo
    allowed-repos: [githubnext/gh-aw-side-repo]
    github-app:
      client-id: ${{ vars.GH_AW_TEST_APP_CLIENT_ID }}
      private-key: ${{ secrets.GH_AW_TEST_APP_PRIVATE_KEY }}
      owner: githubnext
      repositories: [gh-aw-side-repo]
    samples:
      - message: Push with checkout App auth
        patch: |
          diff --git a/phase-d-app-checkout.txt b/phase-d-app-checkout.txt
          new file mode 100644
          --- /dev/null
          +++ b/phase-d-app-checkout.txt
          @@ -0,0 +1 @@
          +GH_AW_CHECKOUT_APP_E2E
---

Create `phase-d-app-checkout.txt` containing `GH_AW_CHECKOUT_APP_E2E` and push it to the supplied side-repository pull request branch.