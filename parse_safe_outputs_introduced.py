import json
import re

issues = json.load(open('issues.json'))

for issue in issues:
    body = issue.get('body', '') or ''
    title = issue.get('title', '') or ''
    num = issue.get('number', '')
    url = issue.get('url', '')
    
    # We want to search for keywords indicating a NEW safe output / handler was introduced.
    text = (title + "\n" + body).lower()
    
    # Check if there is a match in description
    description = ""
    lines = body.split("\n")
    for s in lines:
        s_low = s.lower()
        if any(kw in s_low for kw in ["new", "introduced", "add", "created", "handler", "safe output", "safe-output"]):
            description += s.strip() + " | "
            
    pr_matches = re.findall(r'(?:github/gh-aw#|github\.com/github/gh-aw/pull/)(\d+)', body)
    pr_str = ", ".join(pr_matches) if pr_matches else "None"
    
    safe_output = "Unknown"
    so_match = re.search(r'\*\*(?:Safe|safe)\s*(?:Output|output|Outputs|outputs)\*\*:\s*[`"]?([^`"\n\r]+)[`"]?', body)
    if so_match:
        safe_output = so_match.group(1).strip()
        
    print(f"#{num}: {title}")
    print(f"  URL: {url}")
    print(f"  PRs: {pr_str}")
    print(f"  Safe Output: {safe_output}")
    print(f"  Desc: {description[:300]}")
    print("-" * 50)
