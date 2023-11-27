FROM continuumio/miniconda3:23.3.1-0
ENV LANG en_US.UTF-8
ENV TZ US/Pacific
ARG DEBIAN_FRONTEND=noninteractive

# install maap-py library
ENV MAAP_CONF='/maap-py/'
RUN git clone --single-branch --branch v3.1.3 https://github.com/MAAP-Project/maap-py.git \
    && cd maap-py \
    && pip install -e .

RUN mkdir /projects
WORKDIR /projects
RUN sed -i -e 's/\/root/\/projects/g' /etc/passwd

RUN conda install conda=23.10 && \
    conda install -y -c conda-forge pyOpenSSL=23.2.0

RUN conda install -y -c conda-forge gdal=3.6.2 matplotlib=3.6.2 Cython=0.29.33 h5py=3.7.0 numba=0.56.4 \
    pygeos=0.14 pyproj=3.4.1 rasterio=1.3.4 scipy=1.10.0 \
    && find /opt/conda/ -follow -type f -name '*.a' -delete \
    && find /opt/conda/ -follow -type f -name '*.js.map' -delete \
    && /opt/conda/bin/conda clean -afy

RUN conda --version
ARG IMAGE_REF
ENV DOCKERIMAGE_PATH=${IMAGE_REF}