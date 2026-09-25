import json
import glob
import os

files = glob.glob('trials/triage-32548557621/run-*.json')
for f in sorted(files):
    if os.path.getsize(f) == 0:
        print(f"{f}: (empty)")
        continue
    with open(f) as fh:
        data = json.load(fh)
    # printing key metadata
    print(f"ID: {data.get('databaseId')} | Name: {data.get('name')} | Conclusion: {data.get('conclusion')} | Status: {data.get('status')} | DisplayTitle: {data.get('displayTitle')}")
    # print information about jobs that failed
    for job in data.get('jobs', []):
        if job.get('conclusion') == 'failure':
            print(f"   Failed Job: {job.get('name')} | Step(s): " + ", ".join([s['name'] for s in job.get('steps', []) if s.get('conclusion') == 'failure']))
