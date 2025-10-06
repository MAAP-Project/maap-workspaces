FROM pangeo/pangeo-notebook:2025.08.14

LABEL org.opencontainers.image.source="https://github.com/nasa-impact/pangeo-notebook-veda-image"

USER ${NB_USER}

ADD environment.yml environment.yml

#RUN conda env update --prefix /srv/conda/envs/notebook --file environment.yml
COPY ./environment.yml /tmp
RUN conda env create -y -f "/tmp/environment.yml" \
    && find /srv/conda/ -follow -type f -name '*.a' -delete \
    && find /srv/conda/ -follow -type f -name '*.js.map' -delete \
    && /srv/conda/bin/conda clean -afy

# COPY --chown=${NB_USER}:${NB_USER} image-tests /srv/repo/image-tests
# COPY --chown=${NB_USER}:${NB_USER} scripts /srv/repo/scripts