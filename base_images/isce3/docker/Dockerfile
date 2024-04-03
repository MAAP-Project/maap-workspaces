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

# Set the conda environment for all subsequent docker RUN commands
# When maap-py is updated and installed via our environment.yml,
# we won't need this line unless other envrionment specific commands are added
RUN conda list
SHELL ["conda", "run", "-n", "isce3", "/bin/bash", "-c"]

RUN conda list
RUN mkdir /maap-py \
    && git clone --single-branch --branch bug/unpinned-versions https://github.com/MAAP-Project/maap-py.git /maap-py/ \
    && pip install -e /maap-py/

RUN conda list

ARG IMAGE_REF
ENV DOCKERIMAGE_PATH=${IMAGE_REF}
