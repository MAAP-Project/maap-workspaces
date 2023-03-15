FROM continuumio/miniconda3:4.12.0

RUN conda update -n base -c defaults conda
RUN conda install -y python=3.10.9

# install maap-py library
ENV MAAP_CONF='/maap-py/'
RUN git clone --single-branch --branch master https://github.com/MAAP-Project/maap-py.git \
    && cd maap-py \
    && pip install -e .

RUN mkdir /projects
WORKDIR /projects
RUN sed -i -e 's/\/root/\/projects/g' /etc/passwd && echo "source activate r-with-gdal" > ~/.bashrc
RUN apt-get update && apt-get install -y libxt-dev && apt-get clean

# NOTE: I might have to install a newer version of python here 
RUN conda install -c conda-forge mamba && \
    conda install -y nb_conda_kernels && \
    conda create --name r-with-gdal -c conda-forge r==4.2 gdal r-rgdal r-sf r-irkernel r-gridExtra r-tidyverse \
    r-randomForest r-raster r-data.table r-rlist r-gdalutils r-stringr --yes && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy

ARG IMAGE_REF
ENV DOCKERIMAGE_PATH=${IMAGE_REF}


# Original mamba create 
# mamba create --name r-with-gdal -c conda-forge -c r gdal r-rgdal r-sf r-irkernel r-gridExtra r-tidyverse \
#    r-randomForest r-raster r-rgdal r-data.table r-rlist r-gdalutils r-stringr r-gdalutils --yes && \
