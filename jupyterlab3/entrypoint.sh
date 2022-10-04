#!/bin/bash
# set -ex
# install maap-py stable
# pip install -U --user git+https://gitlab.com/geospec/maap-py.git@stable

# A more robust method of constructing the workspace url prefix
get_workspace_url_prefix() {
	python3 - <<END
import os
import json
import ssl
from urllib.request import urlopen, Request

namespace = "$1" #
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

# Fix Jupyterlab for Che in `single-host` mode. In `single-host` mode, Che uses URL path prefixes
# to distinguish workspaces. So for example, `https://<host>/work/space/path/<jupyter endpoints>`.
# Because of this, we need to set Jupyter's `base_url` to `/work/space/path` so that all hrefs
# and links to files have the correct path prefix. HOWEVER, when the browser accesses those paths,
# the ingress/nginx proxy strips out the `base_url`! Even if the browser makes a request to `/work/space/path/lab`,
# Jupyter's web server, Tornado, only see a request for `/lab`. Tornado routes calls to the correct handler by
# matching the path against a known regular expression. Because `base_url` is configured to `/work/space/path`,
# Tornado only handles requests that have that path prefix, causing calls such as `/lab` to fail. The fix below
# allows `base_url` to be set so that HTTP *responses* include the `base_url` so that browsers make the correct
# call. However, it strips out `base_url` when listening for *requests* so that handles the ingress/nginx proxy
# requests correctly.
export NOTEBOOKLIBPATH=$(find /opt/conda/lib/ -maxdepth 3 -type d -name "notebook")
export JUPYTERSERVERLIBPATH=$(find /opt/conda/lib -maxdepth 3 -type d -name "jupyter_server")

JUPYTER_PATCH=$(cat /opt/jupyter_patch)
if [[ -f "$JUPYTERSERVERLIBPATH/serverapp.py" ]]; then
    perl -pi -e "s|(.*)\(web.Application\):|\$1\(web.Application\):\n$JUPYTER_PATCH|g" "$JUPYTERSERVERLIBPATH/serverapp.py"
    perl -pi -e 's|(.*)__init__\(handlers(.*)|$1__init__\(self.fix_handlers\(handlers, base_url\)$2|g' "$JUPYTERSERVERLIBPATH/serverapp.py"
fi

if [[ -f "$NOTEBOOKLIBPATH/notebookapp.py" ]]; then
    perl -pi -e "s|(.*)\(web.Application\):|\$1\(web.Application\):\n$JUPYTER_PATCH|g" "$NOTEBOOKLIBPATH/notebookapp.py"
    perl -pi -e 's|(.*)__init__\(handlers(.*)|$1__init__\(self.fix_handlers\(handlers, base_url\)$2|g' "$NOTEBOOKLIBPATH/notebookapp.py"
fi

# Dump all env variables into file so they exist still though SSH
# env | grep _ >> /etc/environment


# Add conda bin to path
export PATH=$PATH:/opt/conda/bin
conda init

VERSION=$(jupyter lab --version)
if [[ $VERSION > '2' ]] && [[ $VERSION < '3' ]]; then
    SHELL=/bin/bash jupyter lab --ip=0.0.0.0 --port=3100 --allow-root --NotebookApp.token='' --NotebookApp.base_url=$PREVIEW_URL --no-browser --debug
elif [[ $VERSION > '3' ]] && [[ $VERSION < '4' ]]; then
    SHELL=/bin/bash jupyter lab --ip=0.0.0.0 --port=3100 --allow-root --ContentsManager.allow_hidden=True --ServerApp.token='' --ServerApp.base_url=$PREVIEW_URL --no-browser --debug --ServerApp.disable_check_xsrf=True --collaborative
else
    echo "Error!"
fi
