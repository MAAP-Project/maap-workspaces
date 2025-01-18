FROM debian:12

ARG MINIFORGE_VERSION="24.11.2-1"
RUN apt update -y && apt install -y vim wget git && \
    apt-get clean all

RUN groupadd conda-users

RUN wget -O Miniforge3-installer.sh https://github.com/conda-forge/miniforge/releases/download/${MINIFORGE_VERSION}/Miniforge3-${MINIFORGE_VERSION}-Linux-x86_64.sh && \
    bash Miniforge3-installer.sh -b -p /opt/conda && \
    chgrp -R conda-users /opt/conda/ && chmod -R 775 /opt/conda/ && \
    /opt/conda/bin/conda clean -afy && \
    /opt/conda/bin/conda init bash --system