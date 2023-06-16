FROM continuumio/miniconda3:22.11.1

# Create user ops to be used in DPS
RUN groupadd -g 1000 ops && useradd --uid 1000 --gid 1000 --create-home ops
# install maap-py library
ENV MAAP_CONF='/maap-py/'
RUN git clone --single-branch --branch v3.0.1 https://github.com/MAAP-Project/maap-py.git \
    && cd maap-py \
    && pip install -e .

RUN mkdir /projects
WORKDIR /projects
RUN sed -i -e 's/\/root/\/projects/g' /etc/passwd

RUN conda install -c conda-forge mamba && \
    mamba install -c conda-forge -y gdal=3.4.1 matplotlib=3.5.1 Cython=0.29.28 h5py=3.6.0 numba=0.55.1 \
    pygeos=0.12.0 pyproj=3.3.0 rasterio=1.2.10 scipy=1.8.0 && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy && \
    chgrp -R ops /opt/conda && chmod -R 770 /opt/conda
# https://docs.anaconda.com/anaconda/install/multi-user/?highlight=chgrp#multi-user-anaconda-installation-on-linux

ARG IMAGE_REF
ENV DOCKERIMAGE_PATH=${IMAGE_REF}
