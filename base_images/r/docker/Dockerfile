FROM continuumio/miniconda3:4.12.0

# install maap-py library
ENV MAAP_CONF='/maap-py/'
RUN git clone --single-branch --branch master https://github.com/MAAP-Project/maap-py.git \
    && cd maap-py \
    && pip install -e .

RUN mkdir /projects
WORKDIR /projects
RUN sed -i -e 's/\/root/\/projects/g' /etc/passwd && echo "source activate r-with-gdal" > ~/.bashrc
RUN apt-get update && apt-get install -y libxt-dev && apt-get clean

RUN conda install -c conda-forge mamba && \
    mamba install -y nb_conda_kernels && \
    mamba create --name r-with-gdal -c conda-forge -c r gdal r-rgdal r-sf r-irkernel r-gridExtra r-tidyverse \
    r-randomForest r-raster r-rgdal r-data.table r-rlist r-gdalutils r-stringr r-gdalutils --yes && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy

ARG IMAGE_REF
ENV DOCKERIMAGE_PATH=${IMAGE_REF}
