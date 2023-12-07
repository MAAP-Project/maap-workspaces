FROM continuumio/miniconda3:23.10.0-1
ENV LANG en_US.UTF-8
ENV TZ US/Pacific
ARG DEBIAN_FRONTEND=noninteractive

#RUN set -ex \
# && apt-get update

RUN mkdir /projects
WORKDIR /projects
RUN sed -i -e 's/\/root/\/projects/g' /etc/passwd

COPY ./environment.yml /tmp
RUN conda env create -y -f "/tmp/environment.yml" \
    && find /opt/conda/ -follow -type f -name '*.a' -delete \
    && find /opt/conda/ -follow -type f -name '*.js.map' -delete \
    && /opt/conda/bin/conda clean -afy

RUN conda list

# Set the conda environemnt for all subsequent docker RUN commands
# When maap-py is updated and installed via our environment.yml,
# we won't need this line unless other envrionment specific commands are added
SHELL ["conda", "run", "-n", "r", "/bin/bash", "-c"]

# install maap-py library
ENV MAAP_CONF='/maap-py/'
RUN git clone --single-branch --branch v3.1.3 https://github.com/MAAP-Project/maap-py.git \
    && cd maap-py \
    && pip install -e .

RUN conda list

ARG IMAGE_REF
ENV DOCKERIMAGE_PATH=${IMAGE_REF}