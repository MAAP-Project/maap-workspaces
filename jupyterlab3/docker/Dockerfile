ARG BASE_IMAGE=continuumio/miniconda3:4.10.3p1
FROM ${BASE_IMAGE} as jupyterlab_base

RUN mkdir -p /projects
WORKDIR /projects
RUN sed -i -e 's/\/root/\/projects/g' /etc/passwd

USER root

# Install additional libraries required by Python packages which are in
# the minimal base image. Also install 'rsync' so the 'oc rsync' command
# can be used to copy files into the running container.

RUN apt-get clean && apt-get update && \
    apt-get install -y --no-install-recommends rsync gcc && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Jupyterlab3 does not work with Node 17.x
RUN conda install -c conda-forge jupyterlab=3.2.8 nodejs=16.13.2 gitpython=3.1.26 python=3.8 jupyter-packaging=0.11.1

#ARG NB_USER="ops"
# Adjust permissions on home directory so writable by group root.
RUN chgrp -Rf root /home/$NB_USER && chmod -Rf g+w /home/$NB_USER

# Grant access to jupyterlab config files for base url rewriting
RUN chmod a+rwx -R /opt/conda/lib/python*/site-packages/

# Adjust permissions on /etc/passwd so writable by group root.
RUN chmod g+w /etc/passwd

#ENV ENVIRONMENT=DEV

###############################
# Non Custom Jupyter Extensions.
###############################
RUN conda install -c conda-forge plotly=5.5.0 jupyterlab_widgets=1.0.2 jupyterlab-git=0.34.2
RUN jupyter labextension install --no-build jupyterlab-plotly@5.5.0
# install git extension - needs dev install to modify paths in entrypoint script
#RUN git clone -b v0.20.0 https://github.com/jupyterlab/jupyterlab-git.git
#RUN cd jupyterlab-git && npm install \
#    && npm run build \
#    && jupyter labextension install --no-build \
#    && pip install -e . \
#    && jupyter serverextension enable --py jupyterlab_git --sys-prefix
RUN npm install typescript -g

###############################
# Custom Jupyter Extensions.
###############################
RUN jupyter labextension install @maap-jupyterlab/hide-che-panel-jupyter-extension@1.0.0 --no-build
RUN jupyter labextension install @maap-jupyterlab/jobs-dps-jupyter-extension --no-build

RUN jupyter lab build && \
    jupyter lab clean && \
    jlpm cache clean && \
    npm cache clean --force && \
    rm -rf $HOME/.node-gyp && \
    rm -rf $HOME/.local

RUN find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy && \
    npm cache clean --force

COPY ./entrypoint.sh /entrypoint.sh
COPY ./jupyter_patch /opt/jupyter_patch
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
