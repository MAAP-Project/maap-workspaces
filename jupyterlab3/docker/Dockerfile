ARG BASE_IMAGE
FROM ${BASE_IMAGE} as jupyterlab_base

ARG BASE_IMAGE_TYPE

ADD . /

RUN mkdir -p /projects
WORKDIR /projects
RUN sed -i -e 's/\/root/\/projects/g' /etc/passwd

USER root

RUN conda config --system --add channels conda-forge
RUN conda config --system --remove channels defaults

# Install additional libraries required by Python packages which are in
# the minimal base image. Also install 'rsync' so the 'oc rsync' command
# can be used to copy files into the running container.
RUN apt-get clean && apt-get update && \
    apt-get install -y --no-install-recommends rsync gcc python3 vim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install workspace specific packages for conda environment
RUN echo "Checking if environment.yml exists for ${BASE_IMAGE_TYPE}" \
    ; if [ -f "/${BASE_IMAGE_TYPE}/environment.yml" ]; then \
        echo "Installing packages from '/${BASE_IMAGE_TYPE}/environment.yml'" \
        ; conda env update --name base --file "/${BASE_IMAGE_TYPE}/environment.yml" --solver libmamba \
    ; else \
        echo "Installing packages from '/shared/environment.yml'" \
        ; conda env update --name base --file "/shared/environment.yml" --solver libmamba \
    ; fi

RUN npm install typescript -g
RUN pip install jupyter-server==2.5.0
RUN pip install jupyter-resource-usage==0.7.2

# Adjust permissions on home directory so writable by group root.
RUN chgrp -Rf root /home/$NB_USER && chmod -Rf g+w /home/$NB_USER

# Grant access to jupyterlab config files for base url rewriting
RUN chmod a+rwx -R /opt/conda/lib/python*/site-packages/

# Adjust permissions on /etc/passwd so writable by group root.
RUN chmod g+w /etc/passwd

###############################
# Non Custom Jupyter Extensions
###############################
RUN jupyter labextension install --no-build jupyterlab-plotly@5.5.0
RUN jupyter labextension disable @jupyterlab/apputils-extension:announcements

###############################
# Custom Jupyter Extensions
###############################
RUN jupyter labextension install @maap-jupyterlab/dps-jupyter-extension@0.5.2 --no-build

# PyPi package prepended with 'maap' so it more easily discoverable
RUN pip install maap-jupyter-server-extension==1.2.2
RUN jupyter server extension enable jupyter_server_extension

RUN jupyter labextension install @maap-jupyterlab/algorithms_jupyter_extension@0.2.0 --no-build
RUN jupyter labextension install @maap-jupyterlab/umf-jupyter-extension@1.0.0 --no-build
RUN jupyter labextension install @maap-jupyterlab/maap-libs-jupyter-extension@1.0.2 --no-build
RUN jupyter labextension install @maap-jupyterlab/edsc-jupyter-extension@1.0.4 --no-build
RUN jupyter labextension install @maap-jupyterlab/user-workspace-management-jupyter-extension@0.0.5 --no-build
RUN jupyter labextension install @maap-jupyterlab/maap-help-jupyter-extension@1.0.1 --no-build
RUN jupyter labextension install @maap-jupyterlab/che-sidebar-visibility-jupyter-extension@1.0.1 --no-build

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
