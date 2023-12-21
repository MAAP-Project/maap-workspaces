#!/bin/bash
set -e

# always set this for scripts but don't declare as ENV..
export DEBIAN_FRONTEND=noninteractive

## build ARGs
NCPUS=${NCPUS:--1}

install2.r --error --skipmissing --skipinstalled -n "$NCPUS" \
    Fgmutils \
    nlraa \
    sfarrow 

# Clean up
rm -rf /var/lib/apt/lists/*
rm -r /tmp/downloaded_packages

strip /usr/local/lib/R/site-library/*/libs/*.so