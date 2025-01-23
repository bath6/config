import requests
import json

#must run watcher before running script, or "result" field empty
#get container information from wud
r = requests.get('http://desktop:3001/api/containers')
j = json.loads(r.content)

#parse information for container name, and imageName:tag
version = {}
for i in j:
    name = i["image"]["name"]
    tag = i["result"]["tag"]
    if i["image"]["registry"]["name"] == "ghcr.public":
        # print("ghcr.io/", end = "");
        name = "ghcr.io/" + name
    name = name + ":" + tag
    version.update({i["name"]:name})

#create pretty json from dict
j = json.dumps(version, indent=2)
#write to version.json
with open("version.json", "w") as outfile:
    outfile.write(j)
