#!/bin/bash
set -e

# always set this for scripts but don't declare as ENV..
export DEBIAN_FRONTEND=noninteractive

## build ARGs
NCPUS=${NCPUS:--1}
R_LIB=${R_LIB:-/usr/local/lib/R/site-library}

# Install recommended R packages first to avoid warnings
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r "https://cran.r-project.org" -n "$NCPUS" "codetools"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r "https://cran.r-project.org" -n "$NCPUS" "tidyterra"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r "https://cran.r-project.org" -n "$NCPUS" "BIOMASS"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r "https://cran.r-project.org" -n "$NCPUS" "nlraa"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r "https://cran.r-project.org" -n "$NCPUS" "essentials"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r "https://cran.r-project.org" -n "$NCPUS" "geojsonio"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r "https://cran.r-project.org" -n "$NCPUS" "future"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r "https://r-lidar.r-universe.dev" -n "$NCPUS" "lasR"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r "https://cran.r-project.org" -n "$NCPUS" "partykit"
# Random fields is deprecated as of 2022
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r "https://cran.r-project.org" -n "$NCPUS" "randomForest"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r "https://cran.r-project.org" -n "$NCPUS" "RCSF"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r "https://cran.r-project.org" -n "$NCPUS" "RPostgreSQL"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r "https://cran.r-project.org" -n "$NCPUS" "car"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r "https://cran.r-project.org" -n "$NCPUS" "chron"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r "https://cran.r-project.org" -n "$NCPUS" "egg"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r "https://cran.r-project.org" -n "$NCPUS" "ggpubr"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r "https://cran.r-project.org" -n "$NCPUS" "ggspatial"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r "https://cran.r-project.org" -n "$NCPUS" "ggtext"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r "https://cran.r-project.org" -n "$NCPUS" "gsubfn"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r "https://cran.r-project.org" -n "$NCPUS" "microbenchmark"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r "https://cran.r-project.org" -n "$NCPUS" "minpack.lm"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r "https://cran.r-project.org" -n "$NCPUS" "patchwork"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r "https://cran.r-project.org" -n "$NCPUS" "paws"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r "https://cran.r-project.org" -n "$NCPUS" "pool"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r "https://cran.r-project.org" -n "$NCPUS" "proto"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r "https://cran.r-project.org" -n "$NCPUS" "protolite"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r "https://cran.r-project.org" -n "$NCPUS" "rgee"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r "https://cran.r-project.org" -n "$NCPUS" "rlist"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r "https://cran.r-project.org" -n "$NCPUS" "rnaturalearth"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r "https://cran.r-project.org" -n "$NCPUS" "rockchalk"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r "https://cran.r-project.org" -n "$NCPUS" "RODBC"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r "https://cran.r-project.org" -n "$NCPUS" "rstac"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r "https://cran.r-project.org" -n "$NCPUS" "RStoolbox"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r "https://cran.r-project.org" -n "$NCPUS" "snow"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r "https://cran.r-project.org" -n "$NCPUS" "sqldf"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r "https://cran.r-project.org" -n "$NCPUS" "duckdb"

# Install Bioconductor packages
# BiocManager must be installed first, then use it to install Bioconductor packages
Rscript -e "BiocManager::install('rhdf5', lib = '$R_LIB', Ncpus = $NCPUS, update = FALSE, ask = FALSE)"

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