import json
import re

issues = json.load(open('issues.json'))
print(f"Total issues loaded: {len(issues)}")

for issue in issues:
    body = issue.get('body', '') or ''
    title = issue.get('title', '') or ''
    num = issue.get('number', '')
    url = issue.get('url', '')
    
    # Check if there is mention of safe output or handler inside body or title
    # we can also look for safe outputs mentioned.
    # What are common safe outputs? Let's check mentions of "safe output" or similar
    safe_output_matches = re.findall(r'(?i)safe[-_\s]output', body + " " + title)
    handler_matches = re.findall(r'(?i)handler', body + " " + title)
    
    # Let's print any issue containing "safe" or "output" or specific safe output terms
    # but maybe we can print issue summary highlights to filter down
    if safe_output_matches or "handler" in (body + " " + title).lower():
        print(f"#{num}: {title}")
        # Print first few lines of body or lines with safe-output
        lines = body.split('\n')
        for line in lines[:5]:
            print(f"  {line}")
        print("-" * 40)
