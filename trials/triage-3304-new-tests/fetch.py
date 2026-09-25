import os
import subprocess
import json

run_ids = [
    "33041831637", "33043591596", "33045344555", "33041830113", "33043597576", 
    "33045348932", "33041834609", "33041829699", "33043108343", "33044166317", 
    "33045603620", "33042402159", "33043596651", "33045349297", "33041834684", 
    "33043106259", "33044813144", "33041353240", "33044516112", "33045910035", 
    "33042774782", "33044516002", "33045910206", "33042774800", "33042402004", 
    "33045603717"
]

fields = "attempt,conclusion,createdAt,databaseId,displayTitle,event,headBranch,headSha,jobs,name,number,startedAt,status,updatedAt,url,workflowDatabaseId,workflowName"

os.makedirs("trials/triage-3304-new-tests", exist_ok=True)

for rid in run_ids:
    print(f"Fetching run {rid}...")
    # View JSON
    json_path = f"trials/triage-3304-new-tests/run-{rid}.json"
    subprocess.run(["gh", "run", "view", rid, "--json", fields], stdout=open(json_path, "w"), check=True)
    
    # View log
    log_path = f"trials/triage-3304-new-tests/run-{rid}.log"
    subprocess.run(["gh", "run", "view", rid, "--log"], stdout=open(log_path, "w"), check=True)
    
    # Check if run has failed
    with open(json_path) as f:
        data = json.load(f)
    conclusion = data.get("conclusion")
    status = data.get("status")
    
    if conclusion == "failure":
        print(f"Run {rid} failed, downloading artifacts...")
        # Check if there are artifacts. If none exist/download fails, don't crash
        art_dir = f"trials/triage-3304-new-tests/artifacts-{rid}"
        res = subprocess.run(["gh", "run", "download", rid, "-D", art_dir], capture_output=True, text=True)
        if res.returncode != 0:
            print(f"Artifact download failed or none available for {rid}: {res.stderr.strip()}")

print("All runs fetched.")
