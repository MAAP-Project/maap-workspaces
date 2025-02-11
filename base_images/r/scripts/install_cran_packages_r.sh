#!/bin/bash
set -e

# always set this for scripts but don't declare as ENV..
export DEBIAN_FRONTEND=noninteractive

## build ARGs
NCPUS=${NCPUS:--1}

Rscript /scripts/install2.r --error --skipmissing --skipinstalled -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/Archive/tidyterra/tidyterra_0.6.2.tar.gz"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/Archive/BIOMASS/BIOMASS_2.1.11.tar.gz"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/Archive/nlraa/nlraa_1.9.3.tar.gz"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/Archive/sfarrow/sfarrow_0.4.0.tar.gz"

# Clean up
rm -rf /var/lib/apt/lists/*
if [ -d '/tmp/downloaded_packages' ]; then 
    rm -r /tmp/downloaded_packages
fi
#rm -r /tmp/downloaded_packages

if [ -f '/usr/local/lib/R/site-library/*/libs/*.so' ]; then
    strip /usr/local/lib/R/site-library/*/libs/*.so
fi
#strip /usr/local/lib/R/site-library/*/libs/*.so