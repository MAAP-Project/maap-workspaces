FROM pangeo/pangeo-notebook:2025.08.14
ENV LANG=en_US.UTF-8
ENV TZ=US/Pacific
ARG DEBIAN_FRONTEND=noninteractive

# TODO
# - make sure this builds and puts all necessary info in projects and 
# - starts pangeo by default
# - touch up the environment.yml file and pin packages 

# Copy home directory contents to /projects and set as new home
USER root
RUN mkdir -p /projects && \
    cp -a /home/${NB_USER}/. /projects/ && \
    usermod -d /projects ${NB_USER} && \
    chown -R ${NB_USER}:${NB_USER} /projects
WORKDIR /projects

# should user be root?
USER ${NB_USER}
ENV CONDA_DIR=/srv/conda

RUN conda create -n pangeo --clone notebook

COPY ./environment.yml /tmp
RUN conda env update -n pangeo -f "/tmp/environment.yml" \
    && find ${CONDA_DIR}/ -follow -type f -name '*.a' -delete \
    && find ${CONDA_DIR}/ -follow -type f -name '*.js.map' -delete \
    && ${CONDA_DIR}/bin/conda clean -afy

RUN conda init
USER root
RUN echo ". ${CONDA_DIR}/etc/profile.d/conda.sh ; conda activate pangeo" > /etc/profile.d/init_conda.sh
USER ${NB_USER}

SHELL ["/bin/bash", "-c"]
RUN source activate pangeo && \
    conda list

# ARG IMAGE_REF
# ENV DOCKERIMAGE_PATH_BASE_IMAGE=${IMAGE_REF}
# ARG DEFAULT_DOCKERFILE_PATH
# ENV DOCKERIMAGE_PATH_DEFAULT=${DEFAULT_DOCKERFILE_PATH}