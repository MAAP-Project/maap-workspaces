#!/bin/bash
set -e

# always set this for scripts but don't declare as ENV..
export DEBIAN_FRONTEND=noninteractive

## build ARGs
R_LIB=${R_LIB:-/usr/local/lib/R/site-library}

# Install CRAN packages using pak (much faster with pre-built binaries)
# pak automatically handles parallel downloads and dependency resolution
Rscript -e "pak::pak(c(
  'tidyterra',
  'BIOMASS',
  'nlraa',
  'geojsonio',
  'partykit',
  'randomForest',
  'RCSF',
  'RPostgreSQL',
  'car',
  'chron',
  'egg',
  'ggpubr',
  'ggtext',
  'gsubfn',
  'microbenchmark',
  'minpack.lm',
  'patchwork',
  'paws',
  'pool',
  'proto',
  'protolite',
  'rgee',
  'rlist',
  'rockchalk',
  'RODBC',
  'RStoolbox',
  'snow',
  'sqldf'
), lib = '$R_LIB', ask = FALSE)"

# Install lasR from r-universe (pak supports alternative repos)
Rscript -e "pak::pak('r-lidar/lasR', lib = '$R_LIB', ask = FALSE)"

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