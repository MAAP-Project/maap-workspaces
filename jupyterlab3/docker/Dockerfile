ARG BASE_IMAGE
FROM ${BASE_IMAGE} as jupyterlab_base

ADD . /

RUN mkdir -p /projects
WORKDIR /projects
RUN sed -i -e 's/\/root/\/projects/g' /etc/passwd

USER root

# Install additional libraries required by Python packages which are in
# the minimal base image. Also install 'rsync' so the 'oc rsync' command
# can be used to copy files into the running container.
RUN apt-get clean && apt-get update && \
    apt-get install -y --no-install-recommends rsync gcc python3 vim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Jupyterlab3 does not work with Node 17.x
# Mamba should be installed in all base images
RUN mamba install -c conda-forge gitpython=3.1.26 \
                                 ipyleaflet=0.17.2 \
                                 jupyterlab=3.6.1 \
                                 jupyterlab-git=0.34.2 \
                                 jupyter-packaging=0.12.3 \
                                 jupyterlab_widgets=1.0.2 \
                                 nodejs=16.14.2 \
                                 plotly=5.5.0

RUN npm install typescript -g
RUN pip install xmltodict jupyter-server==2.5.0

# Adjust permissions on home directory so writable by group root.
RUN chgrp -Rf root /home/$NB_USER && chmod -Rf g+w /home/$NB_USER

# Grant access to jupyterlab config files for base url rewriting
RUN chmod a+rwx -R /opt/conda/lib/python*/site-packages/

# Adjust permissions on /etc/passwd so writable by group root.
RUN chmod g+w /etc/passwd

###############################
# Non Custom Jupyter Extensions.
###############################
RUN jupyter labextension install --no-build jupyterlab-plotly@5.5.0

###############################
# Custom Jupyter Extensions.
###############################
RUN jupyter labextension install @maap-jupyterlab/dps-jupyter-extension@latest --no-build

# PyPi package prepended with 'maap' so it more easily discoverable
RUN pip install maap-jupyter-server-extension==1.0.0
RUN jupyter server extension enable jupyter_server_extension

RUN jupyter labextension install @maap-jupyterlab/umf-jupyter-extension@1.0.0 --no-build
RUN jupyter labextension install @maap-jupyterlab/maap-libs-jupyter-extension@1.0.0 --no-build
RUN jupyter labextension install @maap-jupyterlab/edsc-jupyter-extension@latest --no-build
RUN jupyter labextension install @maap-jupyterlab/user-workspace-management-jupyter-extension@0.0.3 --no-build
RUN jupyter labextension install @maap-jupyterlab/maap-help-jupyter-extension@0.0.41 --no-build

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

ENV ENVIRONMENTS_FILE_PATH=/opt/environments.json
COPY ./environments.json $ENVIRONMENTS_FILE_PATH

RUN echo 'printf "\e[101mNOTE: This terminal uses the default environment which might not be the same as your notebook.\e[49m\n\n"' >> /etc/profile

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
