import os
import glob
import re

runs = ["32550237271", "32550237779", "32550240785", "32552358227", "32552358240", "30976492535", "32549823801", "32549825512", "32550240372"]

for r in runs:
    json_path = f"trials/triage-32548557621/run-{r}.json"
    log_path = f"trials/triage-32548557621/run-{r}.log"
    if not os.path.exists(log_path):
        print(f"Run {r}: log not found")
        continue
    
    # Let's inspect failed steps in the log
    with open(log_path, errors='ignore') as f:
        log_content = f.read()
    
    print(f"\n=================== RUN {r} ===================")
    # find lines with ##[error] or similar
    errors = re.findall(r'.*?\[error\].*', log_content)
    if not errors:
        errors = re.findall(r'.*?error:.*', log_content, re.IGNORECASE)
    for err in errors[:10]:
        print("  ", err.strip())
        
    # Let's search inside agent-output-fallback or other artifact files for more details
    art_dir = f"trials/triage-32548557621/artifacts-{r}"
    if os.path.isdir(art_dir):
        # find any files with names like *log*, *diff*, etc.
        mcp_logs = glob.glob(os.path.join(art_dir, "agent/mcp-logs/*"))
        for ml in mcp_logs:
            with open(ml, errors='ignore') as f:
                c = f.read()
                # print some error lines if any
                err_lines = [line for line in c.split('\n') if 'error' in line.lower() or 'exception' in line.lower() or 'failed' in line.lower()]
                if err_lines:
                    print(f"    MCP Log {os.path.basename(ml)}:")
                    for el in err_lines[:5]:
                        print("      ", el.strip())
