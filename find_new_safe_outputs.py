import json
import re

issues = json.load(open('issues.json'))

for issue in issues:
    body = issue.get('body', '') or ''
    title = issue.get('title', '') or ''
    num = issue.get('number', '')
    url = issue.get('url', '')
    
    body_lower = body.lower()
    title_lower = title.lower()
    
    # We want issues whose motivation is that a NEW safe output / handler was introduced.
    # Exclude:
    # - "new options/config fields on an existing safe output" (like comment-memory-config or approve-workflow-run-comment)
    # - "bug fixes to an existing safe output"
    # - "intent metadata changes"
    # - "MCP/runtime/engine features"
    # - "new behavior combinations"
    
    # Let's search for "new safe output" or "new handler" or "added a safe output" or similar
    # also identify the exact safe-output name mentioned. 
    # Let's inspect all issues mentioning any safe output and print them out for screening.
    
    so_match = re.search(r'\*\*(?:Safe|safe)\s*(?:Output|output|Outputs|outputs)\*\*:\s*[`"]?([^`"\n\r\*,#]+)[`"]?', body)
    safe_output = so_match.group(1).strip() if so_match else "Unknown"
    
    # Does the motivation have words like "new", "added", "introduced", "implemented" in relation to the safe output itself?
    # Let's look for phrases like "This PR introduces a new", "added support for a new", "added a new", etc.
    # Or let's print the motivation of each issue so we can manually review and report.
    # To keep it manageable, let's print issue info for those where safe_output is not create-issue (since create-issue is existing)
    if "create-issue" not in safe_output.lower():
        print(f"ISSUE #{num}: {title} (Safe Output: {safe_output})")
        print(f"  URL: {url}")
        # Find first PR
        pr_matches = re.findall(r'(?:github/gh-aw#|github\.com/github/gh-aw/pull/)(\d+)', body)
        print(f"  PRs: {pr_matches}")
        print("  Motivation excerpt:")
        mot_match = re.search(r'## Motivation\s*(.*?)(?:\n##|\Z)', body, re.DOTALL)
        if mot_match:
            lines = [line.strip() for line in mot_match.group(1).split('\n') if line.strip()]
            for l in lines[:4]:
                print(f"    {l}")
        print("-" * 60)
