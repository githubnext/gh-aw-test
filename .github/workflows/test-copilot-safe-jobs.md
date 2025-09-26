---
on: 
  workflow_dispatch:
engine: claude
safe-outputs:
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
        - name: See artifacts
          run: cd /tmp/safe-jobs && ls -lR
        - name: print message
          run: |
                MESSAGE=$(cat "$GITHUB_AW_AGENT_OUTPUT" | jq -r '.items[] | select(.type == "print") | .message')
                if [ -z "$MESSAGE" ]; then
                echo "Error: message is empty"
                exit 1
                fi
                echo "print: $MESSAGE"
                echo "### Print Step Summary" >> "$GITHUB_STEP_SUMMARY"
                echo "$MESSAGE" >> "$GITHUB_STEP_SUMMARY"    
            
---
Summarize and use print the message using the `print` tool.

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.