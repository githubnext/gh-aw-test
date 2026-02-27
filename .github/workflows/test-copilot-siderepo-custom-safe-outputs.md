---
on:
  workflow_dispatch:

permissions: read-all

engine: 
  id: copilot

tools:
  github:
    # The GitHub tools must be authorized to read across-repo 
    github-token: ${{ secrets.TEMP_USER_PAT }}

safe-outputs:
  threat-detection: false
  jobs:
    print:
        #name: "print the message"
        runs-on: ubuntu-latest
        inputs:
            message:
                description: "Message to print"
                required: true
                type: string
        steps:
        - name: print message
          run: |
                MESSAGE=$(cat "$GH_AW_AGENT_OUTPUT" | jq -r '.items[] | select(.type == "print") | .message')
                if [ -z "$MESSAGE" ]; then
                echo "Error: message is empty"
                exit 1
                fi
                echo "print: $MESSAGE"
                echo "### Print Step Summary" >> "$GITHUB_STEP_SUMMARY"
                echo "$MESSAGE" >> "$GITHUB_STEP_SUMMARY"    
---

You have a new tool `print` which takes an input message and prints it to the console.

Use the `print` tool (No Sandbox) to print the following message:

"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

Summarize the message before printing it.
