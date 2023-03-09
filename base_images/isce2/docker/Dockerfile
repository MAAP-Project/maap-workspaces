FROM isce/isce2:v2.6.2 as builder

FROM continuumio/miniconda3:22.11.1 as deploy
ENV LANG en_US.UTF-8
ENV TZ US/Pacific
ARG DEBIAN_FRONTEND=noninteractive

RUN set -ex \
 && apt-get update \
 && apt-get install -y \
    libfftw3-3=3.3.8-2 \
    libgdal28=3.2.2+dfsg-2+deb11u2 \
    libhdf4-0=4.2.15-3 \
    libhdf5-103=1.10.6+repack-4+deb11u1 \
    libopencv-core4.5=4.5.1+dfsg-5 \
    libopencv-highgui4.5=4.5.1+dfsg-5 \
    libopencv-imgproc4.5=4.5.1+dfsg-5 \
    python3-gdal=3.2.2+dfsg-2+deb11u2 \
    python3-h5py=2.10.0-9 \
    python3-numpy=1:1.19.5-1 \
    python3-scipy=1.6.0-2 && \
    apt-get clean


RUN mkdir /projects
WORKDIR /projects
RUN sed -i -e 's/\/root/\/projects/g' /etc/passwd


RUN conda install -y -c conda-forge mamba=1.3.1

RUN mamba install -y -c conda-forge isce2=2.6.2 matplotlib=3.5.1 Cython=0.29.28 \
    numba=0.55.1 pygeos=0.14.0 pyproj=3.4.1 rasterio=1.3.6 && \
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

# COPY --from=builder /usr/lib/python3.8/dist-packages/isce2 /opt/conda/lib/python3.9/dist-packages/isce2
# COPY --from=builder /usr/lib/*gdal* /opt/conda/lib/
