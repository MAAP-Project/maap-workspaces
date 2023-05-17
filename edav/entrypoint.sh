#!/bin/bash

# A more robust method of constructing the workspace url prefix
get_workspace_url_prefix() {
	python3 - <<END
import os
import json
import re
import ssl
from urllib.request import urlopen, Request

namespace = "$1"
# Replicate Che's namespace converter policy
# by substituting any non-alphanumeric characters with hyphens.
namespace = re.sub("[^0-9a-zA-Z-]+", "-", namespace)

svc_host = os.environ.get('KUBERNETES_SERVICE_HOST')
svc_host_https_port = os.environ.get('KUBERNETES_SERVICE_PORT_HTTPS')
che_workspace_id = os.environ.get('CHE_WORKSPACE_ID')
che_machine_name = os.environ.get('CHE_MACHINE_NAME').lower().replace('/', '-')

with open ("/var/run/secrets/kubernetes.io/serviceaccount/token", "r") as t:
    token=t.read()

headers = {
    'Authorization': 'Bearer ' + token,
}

request_string = 'https://' + svc_host + ':' + svc_host_https_port + '/api/v1/namespaces/' + namespace +  '/endpoints/'
httprequest = Request(request_string, headers=headers)
context = ssl._create_unverified_context()
with urlopen(httprequest, context=context) as raw_response:
    response = raw_response.read().decode()
data = json.loads(response)

endpoints = data['items']
for endpoint in endpoints:
    if che_machine_name in endpoint['metadata']['name']:
        if che_workspace_id == endpoint['metadata']['labels']['che.workspace_id']:
            print("/%s/%s" % (endpoint['metadata']['name'], endpoint['subsets'][0]['ports'][0]['name']))
            break
END
}

for i in {1..20}
do
    echo "Attempt $i to construct PREVIEW_URL"
    PREVIEW_URL=$(get_workspace_url_prefix "$CHE_WORKSPACE_NAMESPACE-che") # Che 7 OPS configuration where the (actual) namespace is "<username>-che"
    if test -z "$PREVIEW_URL"
    then
        PREVIEW_URL=$(get_workspace_url_prefix "$CHE_WORKSPACE_NAMESPACE-$CHE_WORKSPACE_ID") # Che 7 UAT configuration fallback where the default namespace is "<username>-<workspaceid>", this will be deprecated
    fi
    if test -z "$PREVIEW_URL"
    then
        PREVIEW_URL=$(get_workspace_url_prefix "$CHE_WORKSPACE_ID") # Che 6 configuration fallback where the default namespace is the workspace id, this will be deprecated
    fi
    if ! test -z "$PREVIEW_URL" # exit loop when it has a preview_url
    then
        break
    fi
done
# end more robust method

perl -pi -e "s|base href=\"|base href=\"$PREVIEW_URL|g" /usr/share/nginx/html/index.html
perl -pi -e "s|80;|3100;|g" /etc/nginx/conf.d/default.conf

. docker-entrypoint.sh

