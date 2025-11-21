#!/bin/bash
set -e

# always set this for scripts but don't declare as ENV..
export DEBIAN_FRONTEND=noninteractive

## build ARGs
NCPUS=${NCPUS:--1}
R_LIB=${R_LIB:-/usr/local/lib/R/site-library}

# Install recommended R packages first to avoid warnings
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/codetools_0.2-20.tar.gz"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/tidyterra_0.7.2.tar.gz"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/minpack.lm_1.2-4.tar.gz"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/BIOMASS_2.2.4-1.tar.gz"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/nlraa_1.9.10.tar.gz"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/essentials_0.1.0.tar.gz"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/geojsonio_0.11.3.tar.gz"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/future_1.68.0.tar.gz"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r NULL -n "$NCPUS" "https://r-lidar.r-universe.dev/src/contrib/lasR_0.17.3.tar.gz"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/partykit_1.2-24.tar.gz"
# randomFields - deprecated and not compatible with R 4.4
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/randomForest_4.7-1.2.tar.gz"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/RCSF_1.0.2.tar.gz"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/RPostgreSQL_0.7-8.tar.gz"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/car_3.1-3.tar.gz"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/chron_2.3-62.tar.gz"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/egg_0.4.5.tar.gz"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/ggpubr_0.6.2.tar.gz"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/ggspatial_1.1.10.tar.gz"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/ggtext_0.1.2.tar.gz"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/gsubfn_0.7.tar.gz"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/microbenchmark_1.5.0.tar.gz"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/patchwork_1.3.2.tar.gz"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/paws_0.9.0.tar.gz"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/pool_1.0.4.tar.gz"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/proto_1.0.0.tar.gz"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/protolite_2.3.1.tar.gz"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/rgee_1.1.8.tar.gz"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/rlist_0.4.6.2.tar.gz"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/rnaturalearth_1.1.0.tar.gz"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/rockchalk_1.8.157.tar.gz"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/RODBC_1.3-26.tar.gz"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/rstac_1.0.1.tar.gz"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/RStoolbox_1.0.2.2.tar.gz"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/snow_0.4-4.tar.gz"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/sqldf_0.4-11.tar.gz"
Rscript /scripts/install2.r --error --skipmissing --skipinstalled -l "$R_LIB" -r NULL -n "$NCPUS" "https://cran.r-project.org/src/contrib/duckdb_1.4.2.tar.gz"

# Install Bioconductor packages
# BiocManager must be installed first, then use it to install Bioconductor packages
Rscript -e "BiocManager::install('rhdf5', version = '2.54.0', lib = '$R_LIB', Ncpus = $NCPUS, update = FALSE, ask = FALSE)"

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