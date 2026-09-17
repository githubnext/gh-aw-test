# External integration E2E fixtures

The Linear, Jira, and GitHub Projects tests mutate real external resources. The
E2E runner reports these tests as `SKIP` until their named repository secrets
and variables exist.

Run all commands below while authenticated to `githubnext/gh-aw-test` with the
GitHub CLI. Secret commands prompt for their values so tokens do not enter shell
history.

## GitHub Projects V2

The workflow currently targets
`https://github.com/orgs/githubnext/projects/1`. Confirm that project exists and
has a `Status` single-select field containing an `In Progress` option. If the
fixture uses another project number, update `project:` in
`.github/workflows/test-copilot-update-project.md` and recompile the workflow.

1. In the `githubnext` organization, open **Projects**, create or select the E2E
   fixture project, and grant the token owner write access.
2. Create a classic PAT with `project` and `repo` scopes. Alternatively, create
   a fine-grained PAT with access to `githubnext/gh-aw-test`, organization
   **Projects: Read and write**, and repository **Issues: Read and write**.
3. Store the token:

   ```bash
   gh secret set GH_AW_PROJECT_GITHUB_TOKEN --repo githubnext/gh-aw-test
   ```

4. Verify access with the same account that owns the token:

   ```bash
   gh auth refresh -s read:project
   gh project view 1 --owner githubnext --format json
   ```

The test creates a temporary GitHub issue, adds it to the project, and sets its
`Status` to `In Progress`. Normal E2E cleanup closes the issue; periodically
remove closed fixture items from the project.

## Linear

Linear safe outputs are experimental in gh-aw.

1. Create or select a Linear workspace and a team dedicated to E2E fixtures.
2. In Linear, open **Settings > Security & access > Personal API keys**, create
   a key named `gh-aw-test`, and copy it once.
3. Find the team's model UUID with the API key:

   ```bash
   curl -s https://api.linear.app/graphql \
     -H "Authorization: $LINEAR_API_KEY" \
     -H 'Content-Type: application/json' \
     --data '{"query":"{ teams { nodes { id key name } } }"}' | jq
   ```

4. Store the API key and team UUID:

   ```bash
   gh secret set LINEAR_API_KEY --repo githubnext/gh-aw-test
   gh variable set LINEAR_TEAM_ID --repo githubnext/gh-aw-test --body '<team-model-uuid>'
   ```

The test creates an issue in that team. Archive test issues periodically; the
GitHub E2E cleanup script cannot remove Linear resources.

## Jira Cloud

1. Create or select an Atlassian Jira Cloud site and a dedicated project. A
   team-managed software project with key `E2E` is sufficient. Ensure the
   account used below can create the `Task` issue type in that project.
2. At <https://id.atlassian.com/manage-profile/security/api-tokens>, create an
   unscoped API token named `gh-aw-test`.
3. Store the site URL and project key as repository variables:

   ```bash
   gh variable set JIRA_BASE_URL --repo githubnext/gh-aw-test --body 'https://<site>.atlassian.net'
   gh variable set JIRA_PROJECT_KEY --repo githubnext/gh-aw-test --body 'E2E'
   ```

4. Store the Atlassian account email and token as repository secrets:

   ```bash
   gh secret set JIRA_USER_EMAIL --repo githubnext/gh-aw-test
   gh secret set JIRA_API_TOKEN --repo githubnext/gh-aw-test
   ```

For a scoped Atlassian token, set `JIRA_BASE_URL` to
`https://api.atlassian.com/ex/jira/<cloudId>` instead. The test creates a Jira
Task; archive test issues periodically because GitHub E2E cleanup cannot remove
them.

## Check configuration

Names can be checked without exposing secret values:

```bash
gh secret list --repo githubnext/gh-aw-test
gh variable list --repo githubnext/gh-aw-test
./e2e.sh --dry-run test-copilot-update-project test-copilot-linear-create-issue test-copilot-jira-create-issue
```