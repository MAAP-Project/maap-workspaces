#!/bin/bash
set -e

# always set this for scripts but don't declare as ENV..
export DEBIAN_FRONTEND=noninteractive

## build ARGs
NCPUS=${NCPUS:--1}

Rscript /scripts/install2.r --error --skipmissing --skipinstalled -n "$NCPUS" nlraa sfarrow
#R -e install.packages('nlraa')

# Clean up
rm -rf /var/lib/apt/lists/*
if [ -d '/tmp/downloaded_packages']; then 
    rm -r /tmp/downloaded_packages
fi
#rm -r /tmp/downloaded_packages

if [ -f '/usr/local/lib/R/site-library/*/libs/*.so']; then
    strip /usr/local/lib/R/site-library/*/libs/*.so
fi
#strip /usr/local/lib/R/site-library/*/libs/*.so