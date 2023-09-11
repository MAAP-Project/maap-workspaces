#!/usr/bin/env bash

# Create temporary file containing our env vars
echo "TITILER_STAC_ENDPOINT=https://titiler-stac.maap-project.org/
TITILER_ENDPOINT=https://titiler.maap-project.org/
STAC_CATALOG_NAME='MAAP STAC'
STAC_CATALOG_URL=https://stac.maap-project.org/" >> /tmp/pangeo_env_vars

# Add our env vars to system environment
cat /etc/environment >> /tmp/pangeo_env_vars
cp /tmp/pangeo_env_vars /etc/environment
rm /tmp/pangeo_env_vars