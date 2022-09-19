FROM continuumio/miniconda3:4.10.3p1

RUN sed -i -e 's/\/root/\/projects/g' /etc/passwd

RUN conda install -c conda-forge mamba && \
    mamba install -c conda-forge -y gdal=3.4.1 matplotlib=3.5.1 nb_conda_kernels=2.3.1 urllib3=1.26.11 && \
    mamba create -n RSGISLib -c conda-forge python=3.8 rsgislib=5.0.10 ipykernel=6.15.3 && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy

ENV MAAP_CONF='/maap-py/'
RUN git clone --single-branch --branch master https://github.com/MAAP-Project/maap-py.git \
    && cd maap-py \
    && python setup.py install

RUN mkdir -p /projects
WORKDIR /projects

ARG IMAGE_REF
ENV DOCKERIMAGE_PATH=${IMAGE_REF}
