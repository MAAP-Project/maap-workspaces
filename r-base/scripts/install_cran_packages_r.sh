#!/bin/bash
set -e

# always set this for scripts but don't declare as ENV..
export DEBIAN_FRONTEND=noninteractive

## build ARGs
R_LIB=${R_LIB:-/usr/local/lib/R/site-library}

# First install packages with C++ dependencies from source to match system libraries
# This ensures terra, sf, etc. are built against the system GDAL/GEOS/PROJ (other binaries built with GDAL 3.4)
echo "Installing spatial packages from source (this may take a while)..."
Rscript -e "install.packages(c('terra', 'sf'), lib = '$R_LIB', type = 'source', repos = 'https://cloud.r-project.org')"

# Install CRAN packages using pak (much faster with pre-built binaries)
# pak automatically handles parallel downloads and dependency resolution
echo "Installing remaining packages..."
Rscript -e "pak::pak(c(
  'BIOMASS',
  'car',
  'chron',
  'egg',
  'geojsonio',
  'ggpubr',
  'ggtext',
  'gsubfn',
  'microbenchmark',
  'minpack.lm',
  'nlraa',
  'partykit',
  'patchwork',
  'paws',
  'pool',
  'proto',
  'protolite',
  'randomForest',
  'RCSF',
  'rgee',
  'rlist',
  'rockchalk',
  'RODBC',
  'RPostgreSQL',
  'RStoolbox',
  'snow',
  'sqldf',
  'tidyterra'
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