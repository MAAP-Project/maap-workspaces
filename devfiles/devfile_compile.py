import yaml
import json
import os

dir_path = os.path.dirname(os.path.realpath(__file__))

INDEX_FILE = "index.json"
META_FILE = "meta.yaml"

# Build the index.json dev registry file
with open(os.path.join(dir_path, INDEX_FILE), "w") as registry_index_file:
    registry_index_file.write("[")

i = 0

for subdir, dirs, files in os.walk(dir_path):
    for file in files:
        if file == META_FILE:
            # Append the devfile metadata to the registry index
            print("Updating " + os.path.join(subdir, file))

            if i > 0:
                with open(os.path.join(dir_path, INDEX_FILE), "a") as registry_index_file:
                    registry_index_file.write(", ")

            i += 1

            with open(os.path.join(subdir, file), 'r') as yaml_in, open(os.path.join(dir_path, INDEX_FILE), "a") as json_out:
                yaml_object = yaml.safe_load(yaml_in) 
                json.dump(yaml_object, json_out)

with open(os.path.join(dir_path, INDEX_FILE), "a") as registry_index_file:
    registry_index_file.write("]")
