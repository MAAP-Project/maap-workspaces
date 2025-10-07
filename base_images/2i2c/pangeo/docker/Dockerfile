#FROM mas.dit.maap-project.org/root/maap-workspaces/custom_images/maap_base:develop
FROM pangeo/pangeo-notebook:2025.08.14
# ENV LANG=en_US.UTF-8
# ENV TZ=US/Pacific
# ARG DEBIAN_FRONTEND=noninteractive

# RUN mkdir /projects
# WORKDIR /projects
# RUN sed -i -e 's/\/root/\/projects/g' /etc/passwd

# should user be root?
USER ${NB_USER}

RUN conda create -n pangeo --clone notebook

COPY ./environment.yml /tmp
RUN conda env update -n pangeo -f "/tmp/environment.yml" \
    && find /srv/conda/ -follow -type f -name '*.a' -delete \
    && find /srv/conda/ -follow -type f -name '*.js.map' -delete \
    && /srv/conda/bin/conda clean -afy

# .bashrc not going to the right place so this isnt actually activating on startup 
RUN conda init && echo "conda activate pangeo" >> ~/.bashrc

SHELL ["/bin/bash", "-c"]
RUN source activate pangeo && \
    conda list

# ARG IMAGE_REF
# ENV DOCKERIMAGE_PATH_BASE_IMAGE=${IMAGE_REF}
# ARG DEFAULT_DOCKERFILE_PATH
# ENV DOCKERIMAGE_PATH_DEFAULT=${DEFAULT_DOCKERFILE_PATH}