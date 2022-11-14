FROM isce/isce2:20220424 as builder

FROM continuumio/miniconda3:4.12.0 as deploy
ENV LANG en_US.UTF-8
ENV TZ US/Pacific
ARG DEBIAN_FRONTEND=noninteractive

RUN set -ex \
 && apt-get update \
 && apt-get install -y \
    libfftw3-3 \
    libgdal28 \
    libhdf4-0 \
    libhdf5-103 \
    libopencv-core4.5 \
    libopencv-highgui4.5 \
    libopencv-imgproc4.5 \
    python3-gdal \
    python3-h5py \
    python3-numpy \
    python3-scipy && \
    apt-get clean


RUN mkdir /projects
WORKDIR /projects
RUN sed -i -e 's/\/root/\/projects/g' /etc/passwd

RUN conda install -c conda-forge mamba && \
    mamba install -y -c conda-forge gdal=3.4.1 matplotlib=3.5.1 Cython=0.29.28 h5py=3.6.0 numba=0.55.1 \
    pygeos=0.12.0 pyproj=3.3.0 rasterio=1.2.10 scipy=1.8.0 && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy

# install maap-py library
ENV MAAP_CONF='/maap-py/'
RUN git clone --single-branch --branch master https://github.com/MAAP-Project/maap-py.git \
    && cd maap-py \
    && pip install -e .

ARG IMAGE_REF
ENV DOCKERIMAGE_PATH=${IMAGE_REF}

COPY --from=builder /usr/lib/python3.8/dist-packages/isce2 /opt/conda/lib/python3.9/dist-packages/isce2
COPY --from=builder /usr/lib/*gdal* /opt/conda/lib/
