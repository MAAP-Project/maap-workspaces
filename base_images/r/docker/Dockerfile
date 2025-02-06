ARG REGISTRY=quay.io
ARG OWNER=jupyter
ARG BASE_IMAGE=$REGISTRY/$OWNER/minimal-notebook:python-3.12

FROM $BASE_IMAGE

ENV LANG en_US.UTF-8
ENV TZ US/Pacific
ARG DEBIAN_FRONTEND=noninteractive

USER root

RUN mkdir /projects
WORKDIR /projects
RUN sed -i -e 's/\/root/\/projects/g' /etc/passwd

USER ${NB_UID}

RUN mamba install --yes \
    'anywidget=0.9.13' \
    'awscli=2.22.15' \
    'backoff=2.2.1' \
    'basemap=1.4.1' \
    'earthaccess=0.12.0' \
    'boto3=1.35.36' \
    'cython=3.0.11' \
    'gdal=3.8.5' \
    'geocube=0.7.0' \
    'geopandas=1.0.1' \
    'groff=1.22.4' \
    'h5py=3.12.1' \
    'hdf5=1.14.3' \
    'httpx=0.28.1' \
    'lonboard=0.10.3' \
    'mapclassify=2.8.1' \
    'matplotlib=3.8.4' \
    'mizani=0.13.1' \
    'numba=0.60.0' \
    'numpy=1.26.4' \
    'pandas=2.2.3' \
    'pandarallel=1.6.5' \
    'parallel=20241122' \
    'perl=5.32.1' \
    'postgis=3.4.2' \
    'pycurl=7.45.3' \
    'pyogrio=0.8.0' \
    'pyproj=3.6.1' \
    'pystac-client=0.8.5' \
    'r=4.3' \
    'r-arrow=17.0.0' \
    'r-aws.s3=0.3.22' \
    'r-base=4.3.3' \
    'r-broom=1.0.7' \
    'r-car=3.1_3' \
    'r-chron=2.3_61' \
    'r-classint=0.4_10' \
    'r-covr=3.6.4' \
    'r-data.table=1.15.4' \
    'r-dbi=1.2.3' \
    'r-deldir=2.0_4' \
    'r-dplyr=1.1.4' \
    'r-egg=0.4.5' \
    'r-essentials=4.3' \
    'r-fs=1.6.5' \
    'r-geojsonio=0.11.3' \
    'r-geojsonsf=2.0.3' \
    'r-geor=1.9_4' \
    'r-geosphere=1.5_20' \
    'r-ggnewscale=0.5.0' \
    'r-ggplot2=3.5.1' \
    'r-ggspatial=1.1.9' \
    'r-ggtext=0.1.2' \
    'r-gridextra=2.3' \
    'r-gstat=2.1_2' \
    'r-gsubfn=0.7' \
    'r-hdf5r=1.3.11' \
    'r-irkernel=1.3.2' \
    'r-jpeg=0.1_10' \
    'r-knitr=1.49' \
    'r-leafem=0.2.3' \
    'r-leaflet=2.2.2' \
    'r-lidr=4.1.2' \
    'r-lwgeom=0.2_14' \
    'r-mapdata=2.3.1' \
    'r-mapproj=1.2.11' \
    'r-maps=3.4.2.1' \
    'r-maptools=1.1_8' \
    'r-mapview=2.11.2' \
    'r-microbenchmark=1.5.0' \
    'r-ncdf4=1.23' \
    'r-nlme=3.1_165' \
    'r-patchwork=1.3.0' \
    'r-paws=0.7.0' \
    'r-plogr=0.2.0' \
    'r-plyr=1.8.9' \
    'r-png=0.1_8' \
    'r-pool=1.0.4' \
    'r-proj4=1.0_14' \
    'r-proto=1.0.0' \
    'r-protolite=2.3.0' \
    'r-randomfields=3.3.14' \
    'r-randomforest=4.7_1.2' \
    'r-raster=3.6_30' \
    'r-rcolorbrewer=1.1_3' \
    'r-readxl=1.4.3' \
    'r-reticulate=1.40.0' \
    'r-rgdal=1.6_7' \
    'r-rgee=1.1.7' \
    'r-rgeos=0.6_4' \
    'r-rlas=1.6.2' \
    'r-rlist=0.4.6.2' \
    'r-rmarkdown=2.29' \
    'r-rnaturalearth=1.0.1' \
    'r-rnaturalearthdata=1.0.0' \
    'r-rnetcdf=2.9_2' \
    'r-rockchalk=1.8.157' \
    'r-rodbc=1.3_25' \
    'r-rpostgres=1.4.7' \
    'r-rpostgresql=0.7_7' \
    'r-rsqlite=2.3.9' \
    'r-rstac=1.0.1' \
    'r-scales=1.3.0' \
    'r-sf=1.0_16' \
    'r-snow=0.4_4' \
    'r-spacetime=1.3_2' \
    'r-spatialreg=1.3_6' \
    'r-spatstat=3.3_0' \
    'r-spdep=1.3_8' \
    'r-sqldf=0.4_11' \
    'r-stars=0.6_6' \
    'r-stringr=1.5.1' \
    'r-terra=1.7_78' \
    'r-testthat=3.2.1.1' \
    'r-tibble=3.2.1' \
    'r-tidync=0.4.0' \
    'r-tidyr=1.3.1' \
    'r-tidyverse=2.0.0' \
    'r-tmap=3.3_4' \
    'r-units=0.8_5' \
    'r-viridis=0.6.5' \
    'rasterio=1.3.10' \
    'rasterstats=0.20.0' \
    'requests=2.32.3' \
    'rio-cogeo=5.4.0' \
    'rtree=1.3.0' \
    's3fs=2024.10.0' \
    'scikit-learn=1.6.0' \
    'scipy=1.14.1' \
    'seaborn=0.13.2' \
    'shapely=2.0.4' \
    'sliderule=4.8.6' \
    'statsmodels=0.14.4' \
    'tqdm=4.67.1' \
    'unidecode=1.3.8' \
    'unzip=6.0' \
    'xmltodict=0.14.2' \
    'pip=24.3.1' && \
    pip install ff==0.0.10 grid==0.7.1 earthengine-api==1.4.3 morecantile==6.1.0 rio-tiler==7.2.2 mpl-scatter-density==0.8 && \
    mamba clean --all -f -y  && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}" && \
    conda install r::r-devemf=4.4_1 r-biocmanager=1.30.25

SHELL ["/bin/bash", "-c"]
ARG IMAGE_REF
ENV DOCKERIMAGE_PATH=${IMAGE_REF}