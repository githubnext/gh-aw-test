import json
import re

issues = json.load(open('issues.json'))

for issue in issues:
    body = issue.get('body', '') or ''
    title = issue.get('title', '') or ''
    num = issue.get('number', '')
    url = issue.get('url', '')
    
    text = (title + " " + body).lower()
    
    # We want to identify any issues related to safe outputs / handlers.
    # Let's find matches for: "safe output", "safe-output", "safe_output", "handler"
    if any(q in text for q in ["safe output", "safe-output", "safe_output", "handler"]):
        print(f"=== ISSUE #{num} ===")
        print(f"Title: {title}")
        print(f"URL: {url}")
        # Look for PR links
        prs = re.findall(r'github/gh-aw#\d+|github\.com/github/gh-aw/pull/\d+|github\.com/github/gh-aw/issues/\d+', body)
        if prs:
            print(f"PRs: {prs}")
        # Let's find any mentions of names like copilot/something or safe-output name
        # Safe outputs are often specified like safe-outputs / handlers
        print("Body snippet:")
        # Print lines containing safe and outline context
        lines = body.split('\n')
        for i, line in enumerate(lines):
            if any(q in line.lower() for q in ["safe", "handler", "motivation", "proposed test"]):
                start = max(0, i-2)
                end = min(len(lines), i+3)
                print(f"--- lines {start}-{end} ---")
                for j in range(start, end):
                    print(f"  {lines[j]}")
                print("-------------------")
        print("\n" + "="*80 + "\n")
