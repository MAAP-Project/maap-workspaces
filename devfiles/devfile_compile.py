import yaml
import json
import os

dir_path = os.path.dirname(os.path.realpath(__file__))

INDEX_FILE = "index.json"
META_FILE = "meta.yaml"

with open(INDEX_FILE, "w") as myfile:
    myfile.write("[")

i = 0

for subdir, dirs, files in os.walk(dir_path):
    for file in files:
        if file == META_FILE:
            print("Updating " + os.path.join(subdir, file))

            if i > 0:
                with open(INDEX_FILE, "a") as myfile:
                    myfile.write(", ")

            i += 1

            with open(os.path.join(subdir, file), 'r') as yaml_in, open(INDEX_FILE, "a") as json_out:
                yaml_object = yaml.safe_load(yaml_in) 
                json.dump(yaml_object, json_out)

with open(INDEX_FILE, "a") as myfile:
    myfile.write("]")
