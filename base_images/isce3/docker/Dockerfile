FROM continuumio/miniconda3:22.11.1
ENV LANG en_US.UTF-8
ENV TZ US/Pacific
ARG DEBIAN_FRONTEND=noninteractive

# install maap-py library
ENV MAAP_CONF='/maap-py/'
RUN git clone --single-branch --branch v3.0.1 https://github.com/MAAP-Project/maap-py.git \
    && cd maap-py \
    && pip install -e .

RUN set -ex \
 && apt-get update

RUN mkdir /projects
WORKDIR /projects
RUN sed -i -e 's/\/root/\/projects/g' /etc/passwd

RUN conda install -y -c conda-forge pyOpenSSL=23.2.0 && \
    conda install -y -n base conda-libmamba-solver=23.7.0 && \
    conda config --set solver libmamba

RUN conda install -y --solver=libmamba -c conda-forge isce3=0.12.0 xarray=2023.4.2 \
    hvplot=0.8.3 fsspec=2023.5.0 scikit-learn=1.2.2 && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy

RUN pip install git+https://github.com/opera-adt/RTC.git@v0.3

ARG IMAGE_REF
ENV DOCKERIMAGE_PATH=${IMAGE_REF}
