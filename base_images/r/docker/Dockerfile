FROM continuumio/miniconda3:4.10.3p1

ARG IMAGE_REF

RUN mkdir /projects
WORKDIR /projects
RUN sed -i -e 's/\/root/\/projects/g' /etc/passwd

RUN conda install -c r r=3.6.0 && conda install -c conda-forge mamba r-essentials r-base r-irkernel r-rgdal --yes
RUN mamba install fonts-anaconda

# install maap-py library
ENV MAAP_CONF='/maap-py/'
RUN git clone --single-branch --branch master https://github.com/MAAP-Project/maap-py.git \
    && cd maap-py \
    && pip install -e .

RUN mamba install nb_conda_kernels
RUN apt-get update && apt-get install -y libxt-dev

SHELL ["/bin/bash", "-c"]
RUN mamba create --name r-with-gdal -c conda-forge -c r gdal r-rgdal r-sf r-irkernel r-gridExtra r-tidyverse r-randomForest r-raster r-rgdal r-data.table r-rlist r-gdalutils r-stringr r-gdalutils --yes
RUN echo "source activate r-with-gdal" > ~/.bashrc

RUN groupadd conda-users && chgrp -R conda-users /opt/conda && chmod 770 -R /opt/conda
ENV DOCKERIMAGE_PATH=${IMAGE_REF}
RUN find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy
