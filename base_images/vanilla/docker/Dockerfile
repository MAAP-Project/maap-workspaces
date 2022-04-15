FROM continuumio/miniconda3:4.10.3p1

ARG IMAGE_REF

RUN mkdir /projects
WORKDIR /projects
RUN sed -i -e 's/\/root/\/projects/g' /etc/passwd

RUN conda install -c conda-forge mamba && \
    mamba install -c conda-forge gdal=3.4.1 matplotlib=3.5.1 Cython=0.29.28 h5py=3.6.0 numba=0.55.1 \
    pygeos=0.12.0 pyproj=3.3.0 rasterio=1.2.10 scipy=1.8.0

# install maap-py library
ENV MAAP_CONF='/maap-py/'
RUN git clone --single-branch --branch master https://github.com/MAAP-Project/maap-py.git \
    && cd maap-py \
    && pip install -e .

RUN groupadd conda-users && chgrp -R conda-users /opt/conda && chmod 770 -R /opt/conda
ENV DOCKERIMAGE_PATH=${IMAGE_REF}
RUN find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy
