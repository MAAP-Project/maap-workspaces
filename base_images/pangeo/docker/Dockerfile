FROM continuumio/miniconda3:23.5.2-0
ENV LANG en_US.UTF-8
ENV TZ US/Pacific
ARG DEBIAN_FRONTEND=noninteractive

# install maap-py library
ENV MAAP_CONF='/maap-py/'
RUN git clone --single-branch --branch v3.0.1 https://github.com/MAAP-Project/maap-py.git \
    && cd maap-py \
    && pip install -e .

RUN mkdir /projects
WORKDIR /projects
RUN sed -i -e 's/\/root/\/projects/g' /etc/passwd

#RUN conda install -n base conda=23.7.4
RUN conda install -n base conda-libmamba-solver
RUN conda config --set solver libmamba
RUN conda install -n base --solver=libmamba -c conda-forge -y cython=3.0.2 gdal=3.7.0 h5py=3.9.0 matplotlib=3.8.0 numba=0.57.1 \
    pygeos=0.14 pyproj=3.6.0 rasterio=1.3.8 scipy=1.11.2 \
    && find /opt/conda/ -follow -type f -name '*.a' -delete \
    && find /opt/conda/ -follow -type f -name '*.js.map' -delete \
    && /opt/conda/bin/conda clean -afy

ARG IMAGE_REF
ENV DOCKERIMAGE_PATH=${IMAGE_REF}