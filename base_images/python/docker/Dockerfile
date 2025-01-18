FROM mas.dit.maap-project.org/root/maap-workspaces/custom_images/maap_base:39ca721
ENV LANG en_US.UTF-8
ENV TZ US/Pacific
ARG DEBIAN_FRONTEND=noninteractive

RUN mkdir /projects
WORKDIR /projects
RUN sed -i -e 's/\/root/\/projects/g' /etc/passwd

COPY ./environment.yml /tmp
RUN conda env create -y -f "/tmp/environment.yml" \
    && find /opt/conda/ -follow -type f -name '*.a' -delete \
    && find /opt/conda/ -follow -type f -name '*.js.map' -delete \
    && /opt/conda/bin/conda clean -afy

RUN conda init && echo "conda activate python" >> ~/.bashrc

SHELL ["/bin/bash", "-c"]
RUN source activate python && \
    conda list

ARG IMAGE_REF
ENV DOCKERIMAGE_PATH_BASE_IMAGE=${IMAGE_REF}
ARG DEFAULT_DOCKERFILE_PATH
ENV DOCKERIMAGE_PATH_DEFAULT=${DEFAULT_DOCKERFILE_PATH}