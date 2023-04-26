FROM continuumio/miniconda3:22.11.1
ENV LANG en_US.UTF-8
ENV TZ US/Pacific
ARG DEBIAN_FRONTEND=noninteractive

# install maap-py library
ENV MAAP_CONF='/maap-py/'
RUN git clone --single-branch --branch master https://github.com/MAAP-Project/maap-py.git \
    && cd maap-py \
    && pip install -e .

RUN mkdir /projects
WORKDIR /projects
RUN sed -i -e 's/\/root/\/projects/g' /etc/passwd

RUN conda install -c conda-forge mamba && \
    mamba install -c conda-forge -y gdal=3.6.2 matplotlib=3.6.2 Cython=0.29.33 h5py=3.7.0 numba=0.56.4 \
    pygeos=0.14 pyproj=3.4.1 rasterio=1.3.4 scipy=1.10.0 \
    && find /opt/conda/ -follow -type f -name '*.a' -delete \
    && find /opt/conda/ -follow -type f -name '*.js.map' -delete \
    && /opt/conda/bin/conda clean -afy

ARG IMAGE_REF
ENV DOCKERIMAGE_PATH=${IMAGE_REF}