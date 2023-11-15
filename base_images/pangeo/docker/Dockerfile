FROM continuumio/miniconda3:23.3.1-0
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

RUN conda install -y -c conda-forge -n base libarchive && \
    conda install -y -c conda-forge -n base pyOpenSSL=23.2.0 && \
    conda install -y -c conda-forge -n base conda-libmamba-solver && \
    conda config --set solver libmamba

COPY ./environment.yml /tmp
RUN conda env update --solver=libmamba -n base --file "/tmp/environment.yml" \
    && find /opt/conda/ -follow -type f -name '*.a' -delete \
    && find /opt/conda/ -follow -type f -name '*.js.map' -delete \
    && /opt/conda/bin/conda clean -afy

ARG IMAGE_REF
ENV DOCKERIMAGE_PATH=${IMAGE_REF}