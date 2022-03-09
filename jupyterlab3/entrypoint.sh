#!/bin/bash
# set -ex
# install maap-py stable
# pip install -U --user git+https://gitlab.com/geospec/maap-py.git@stable

# Reconstruct Che preview url
THE_MACHINE=''

# Get the Che machine name from either MACHINE_NAME, used by Che v6, or CHE_MACHINE_NAME, used by Che v7
if [[ -z "${MACHINE_NAME}" ]]; then
  THE_MACHINE=`echo $CHE_MACHINE_NAME | tr 'a-z' 'A-Z' | tr '-' '_' | tr '/' '_'`
else
  THE_MACHINE="${MACHINE_NAME}"
fi

export PREVIEW_URL=`/usr/bin/printenv | grep "$THE_MACHINE" | perl -slane 'if(/^(SERVER[^_]+_$mn)_SERVICE_PORT=(\d+)/) { $p=$2; print "/".lc($1=~s/_/-/rg)."/server-".$p; }' -- -mn=$THE_MACHINE | uniq`

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
    jupyter lab --ip=0.0.0.0 --port=3100 --allow-root --NotebookApp.token='' --NotebookApp.base_url=$PREVIEW_URL --no-browser --debug
elif [[ $VERSION > '3' ]] && [[ $VERSION < '4' ]]; then
    jupyter lab --ip=0.0.0.0 --port=3100 --allow-root --ContentsManager.allow_hidden=True --ServerApp.token='' --ServerApp.base_url=$PREVIEW_URL --no-browser --debug --ServerApp.disable_check_xsrf=True
else
    echo "Error!"
fi
