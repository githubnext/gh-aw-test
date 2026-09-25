import json
import re

issues = json.load(open('issues.json'))

for issue in issues:
    body = issue.get('body', '') or ''
    title = issue.get('title', '') or ''
    num = issue.get('number', '')
    url = issue.get('url', '')
    
    text = (title + "\n" + body).lower()
    
    # We want to search for actual mentions of "safe output" (with space/dash/underscore) or "handler" (specifically safe-output handler, api-handler, output handler, action handler, etc.)
    # Let's count matching phrases
    has_safe_output = ("safe-output" in text) or ("safe output" in text) or ("safe_output" in text) or ("handler" in text)
    
    if has_safe_output:
        # Let's see if we can find references to specific safe outputs or safe output handlers
        # Let's print the title and any sentence or phrase with "safe" or "handler" in it.
        # Often, safe outputs are registered or mentioned.
        print(f"#{num}: {title}")
        print(f"URL: {url}")
        
        # Pull out PR references
        prs = re.findall(r'(?:github/gh-aw#|github\.com/github/gh-aw/pull/)(\d+)', body)
        if prs:
            print(f"  PRs: {prs}")
            
        sentences = re.split(r'\.|\n', body)
        for s in sentences:
            s_low = s.lower()
            if any(q in s_low for q in ["safe-output", "safe output", "safe_output", "handler"]):
                print(f"  -> {s.strip()}")
        print("-" * 50)

