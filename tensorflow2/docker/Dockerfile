FROM quay.io/pangeo/ml-notebook:2026.06.04
ENV LANG=en_US.UTF-8
ENV TZ=US/Pacific
ARG DEBIAN_FRONTEND=noninteractive

# Install additional packages from environment.yml
COPY tensorflow2/environment.yml /tmp
RUN conda env update -n ${CONDA_ENV} -f "/tmp/environment.yml" \
    && find ${CONDA_DIR}/ -follow -type f -name '*.a' -delete \
    && find ${CONDA_DIR}/ -follow -type f -name '*.js.map' -delete \
    && ${CONDA_DIR}/bin/conda clean -afy

# Install shared MAAP extensions
COPY maap-extensions-versions.txt /tmp/
RUN ${CONDA_DIR}/envs/${CONDA_ENV}/bin/pip install -r /tmp/maap-extensions-versions.txt

RUN conda init