ARG BASE_IMAGE
ARG BASE_IMAGE_TYPE

FROM ${BASE_IMAGE} as jupyterlab_base
ARG BASE_IMAGE_TYPE
# Set WORKSPACE_TYPE, used by entrypoint.sh
ENV WORKSPACE_TYPE=${BASE_IMAGE_TYPE}

# Create base images for each workspace needed for build stage later
FROM jupyterlab_base as workspace_base_pangeo
SHELL ["conda", "run", "-n", "pangeo", "/bin/bash", "-c"]

FROM jupyterlab_base as workspace_base_vanilla
SHELL ["conda", "run", "-n", "vanilla", "/bin/bash", "-c"]

FROM jupyterlab_base as workspace_base_r
SHELL ["conda", "run", "-n", "r", "/bin/bash", "-c"]

FROM jupyterlab_base as workspace_base_isce3
SHELL ["conda", "run", "-n", "isce3", "/bin/bash", "-c"]

FROM workspace_base_${BASE_IMAGE_TYPE} AS workspace_base

FROM workspace_base as workspace_build_stage

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
RUN echo "Checking if environment.yml exists for ${WORKSPACE_TYPE}" \
    ; if [ -f "/${WORKSPACE_TYPE}/environment.yml" ]; then \
        echo "Installing packages from '/${WORKSPACE_TYPE}/environment.yml'" \
        ; conda env update --file "/${WORKSPACE_TYPE}/environment.yml" \
    ; else \
        sed -i "s/WORKSPACE_ENVIRONMENT_NAME/${WORKSPACE_TYPE}/g" /shared/environment.yml \
        ; echo "Installing packages from '/shared/environment.yml'" \
        ; conda env update --file "/shared/environment.yml" \
    ; fi

RUN npm install typescript -g

# Adjust permissions on home directory so writable by group root.
RUN chgrp -Rf root /home/$NB_USER && chmod -Rf g+w /home/$NB_USER

# Grant access to jupyterlab config files for base url rewriting
RUN chmod a+rwx -R /opt/conda/lib/python*/site-packages/

# Adjust permissions on /etc/passwd so writable by group root.
RUN chmod g+w /etc/passwd

###############################
# Non Custom Jupyter Extensions
###############################
RUN jupyter labextension disable @jupyterlab/apputils-extension:announcements
# REMOVE THIS LINE LATER
RUN npm install jupyterlab-plotly@5.5.0 

###############################
# Custom Jupyter Extensions
###############################

# Jupyter server extension needs to be specifially enabled 
#RUN jupyter server extension enable jupyter_server_extension
RUN pip install -i https://test.pypi.org/simple/ maap-jupyter-server-extension==2.0.2
RUN jupyter server extension enable maap_jupyter_server_extension

RUN pip install -i https://test.pypi.org/simple/ maap-dps-jupyter-extension
RUN pip install -i https://test.pypi.org/simple/ maap-algorithms-jupyter-extension
RUN pip install -i https://test.pypi.org/simple/ maap-libs-jupyter-extension
RUN pip install -i https://test.pypi.org/simple/ maap-edsc-jupyter-extension
RUN pip install -i https://test.pypi.org/simple/ maap-user-workspace-management-jupyter-extension
RUN pip install -i https://test.pypi.org/simple/ maap-help-jupyter-extension
RUN pip install -i https://test.pypi.org/simple/ maap-che-sidebar-visibility-jupyter-extension

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

RUN conda list

# Reset Shell
SHELL ["/bin/sh", "-c"]

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]