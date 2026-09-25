import json
import re

issues = json.load(open('issues.json'))

for issue in issues:
    body = issue.get('body', '') or ''
    title = issue.get('title', '') or ''
    num = issue.get('number', '')
    url = issue.get('url', '')
    
    # Let's extract:
    # 1. Title
    # 2. PR link
    # 3. Safe output mentioned (e.g. searching for `- **Safe output**:` or similar patterns in the body)
    # 4. First 10 lines of Motivation
    
    pr_matches = re.findall(r'(?:github/gh-aw#|github\.com/github/gh-aw/pull/)(\d+)', body)
    pr_str = ", ".join(pr_matches) if pr_matches else "None"
    
    safe_output = "Unknown"
    so_match = re.search(r'\*\*(?:Safe|safe)\s*(?:Output|output|Outputs|outputs)\*\*:\s*[`"]?([^`"\n\r]+)[`"]?', body)
    if so_match:
        safe_output = so_match.group(1).strip()
        
    motivation = "No motivation section found"
    mot_match = re.search(r'## Motivation\s*(.*?)(?:\n##|\Z)', body, re.DOTALL)
    if mot_match:
        motivation = mot_match.group(1).strip()
        # Keep first 5 lines
        lines = [line.strip() for line in motivation.split('\n') if line.strip()][:5]
        motivation = " | ".join(lines)
        
    print(f"ISSUE #{num}: {title}")
    print(f"  URL: {url}")
    print(f"  PRs: {pr_str}")
    print(f"  Safe Output: {safe_output}")
    print(f"  Motivation Quote: {motivation[:300]}")
    print("-" * 80)
