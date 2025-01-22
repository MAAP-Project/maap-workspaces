FROM debian:11

ARG MINIFORGE_VERSION="24.11.2-1"
RUN apt-get update -y && apt-get install -y vim wget git && \
    apt-get clean all

RUN groupadd conda-users

RUN wget -O Miniforge3-installer.sh https://github.com/conda-forge/miniforge/releases/download/${MINIFORGE_VERSION}/Miniforge3-${MINIFORGE_VERSION}-Linux-x86_64.sh && \
    bash Miniforge3-installer.sh -b -p /opt/conda && \
    chgrp -R conda-users /opt/conda/ && chmod -R 775 /opt/conda/ && \
    /opt/conda/bin/conda clean -afy && \
    echo "source /opt/conda/etc/profile.d/conda.sh" >> /root/.bashrc

ENV PATH=/opt/conda/bin:$PATH