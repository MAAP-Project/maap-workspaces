#!/bin/bash
set -e

# always set this for scripts but don't declare as ENV..
export DEBIAN_FRONTEND=noninteractive

## build ARGs
NCPUS=${NCPUS:--1}

# Install CRAN packages using conda's R installation instead of Posit R to avoid library conflicts
# Download and install Posit's patched R 4.3.3 binary
curl -O https://cdn.posit.co/r/debian-11/pkgs/r-4.3.3_1_$(dpkg --print-architecture).deb
apt-get update
apt-get install -y curl libjpeg62-turbo
apt-get install -y ./r-4.3.3_1_$(dpkg --print-architecture).deb
rm r-4.3.3_1_$(dpkg --print-architecture).deb

# Configure Posit R to use conda environment library paths
echo 'R_LIBS_USER="/opt/conda/envs/r/lib/R/library"' >> /opt/R/4.3.3/lib/R/etc/Renviron
echo '.libPaths("/opt/conda/envs/r/lib/R/library")' >> /opt/R/4.3.3/lib/R/etc/Rprofile.site

# Replace conda's R binary with Posit's patched version but keep using conda environment
cp /opt/R/4.3.3/bin/R /opt/conda/envs/r/bin/R
cp /opt/R/4.3.3/bin/Rscript /opt/conda/envs/r/bin/Rscript

# Install CRAN packages using the patched R in conda environment with explicit library path
/opt/conda/envs/r/bin/Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "/opt/conda/envs/r/lib/R/library" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/Archive/tidyterra/tidyterra_0.6.2.tar.gz"
/opt/conda/envs/r/bin/Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "/opt/conda/envs/r/lib/R/library" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/Archive/BIOMASS/BIOMASS_2.1.11.tar.gz"
/opt/conda/envs/r/bin/Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "/opt/conda/envs/r/lib/R/library" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/Archive/nlraa/nlraa_1.9.3.tar.gz"
/opt/conda/envs/r/bin/Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "/opt/conda/envs/r/lib/R/library" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/Archive/sfarrow/sfarrow_0.4.0.tar.gz"

# Clean up
apt-get clean
rm -rf /var/lib/apt/lists/*

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