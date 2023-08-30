#!/usr/bin/env bash

echo "
# Pangeo Environment Variables
export TITILER_STAC_ENDPOINT=https://titiler-stac.maap-project.org/
export TITILER_ENDPOINT=https://titiler.maap-project.org/
export STAC_CATALOG={"name": "MAAP STAC", "url": "https://stac.maap-project.org/"}
" >> /etc/bash.bashrc