ARG BASE_IMAGE
ARG BASE_IMAGE_TYPE

FROM ${BASE_IMAGE} as jupyterlab_base
ARG BASE_IMAGE_TYPE
# Set WORKSPACE_TYPE, used by entrypoint.sh
ENV WORKSPACE_TYPE=${BASE_IMAGE_TYPE}

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

# Adjust permissions on home directory so writable by group root.
RUN chgrp -Rf root /home/$NB_USER && chmod -Rf g+w /home/$NB_USER

# Grant access to jupyterlab config files for base url rewriting
RUN chmod a+rwx -R /opt/conda/lib/python*/site-packages/

# Adjust permissions on /etc/passwd so writable by group root.
RUN chmod g+w /etc/passwd

###############################
# Non Custom Jupyter Extensions
###############################
# RUN jupyter labextension disable @jupyterlab/apputils-extension:announcements

###############################
# Custom Jupyter Extensions
###############################

# PyPi packages prepended with 'maap' so they are more easily discoverable
#SHELL ["/bin/bash", "-c"] # Added this line to base image dockerfiles for now before maap-py is extracted to environment.yml
# Jupyter server extension needs to be specifially enabled 
RUN source activate $WORKSPACE_TYPE && \
    npm install typescript -g && \
    jupyter labextension disable @jupyterlab/apputils-extension:announcements && \
    jupyter server extension enable maap_jupyter_server_extension

RUN source activate $WORKSPACE_TYPE && \
    jupyter lab build && \
    jupyter lab clean && \
    npm cache clean --force && \
    rm -rf $HOME/.node-gyp && \
    rm -rf $HOME/.local

RUN source activate $WORKSPACE_TYPE && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy && \
    npm cache clean --force && \
    conda list

COPY ./maap_algorithms_jupyter_extension-0.3.4-py3-none-any.whl /maap_algorithms_jupyter_extension-0.3.4-py3-none-any.whl
RUN source activate $WORKSPACE_TYPE && \
    pip install /maap_algorithms_jupyter_extension-0.3.4-py3-none-any.whl

COPY ./entrypoint.sh /entrypoint.sh
COPY ./jupyter_patch /opt/jupyter_patch

ENV ENVIRONMENTS_FILE_PATH=/opt/environments.json
COPY ./environments.json $ENVIRONMENTS_FILE_PATH

RUN echo 'printf "\e[101mNOTE: This terminal uses the default environment which might not be the same as your notebook.\e[49m\n\n"' >> /etc/profile

# Reset Shell
SHELL ["/bin/sh", "-c"]

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]