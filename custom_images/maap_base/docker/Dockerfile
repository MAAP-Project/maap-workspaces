FROM ubuntu:24.04

ARG MINIFORGE_VERSION="24.11.2-1"
RUN apt-get update -y && apt-get install -y vim wget git gnupg && \
    apt-get clean all

RUN groupadd conda-users

RUN wget -O Miniforge3-installer.sh https://github.com/conda-forge/miniforge/releases/download/${MINIFORGE_VERSION}/Miniforge3-${MINIFORGE_VERSION}-Linux-x86_64.sh && \
    bash Miniforge3-installer.sh -b -p /opt/conda && \
    chgrp -R conda-users /opt/conda/ && chmod -R 775 /opt/conda/ && \
    /opt/conda/bin/conda clean -afy && \
    echo "source /opt/conda/etc/profile.d/conda.sh" >> /root/.bashrc

RUN apt-get update && apt-get install -y software-properties-common

RUN ls /etc/apt/sources.list.d

#RUN add-apt-repository ppa:ubuntugis/ubuntugis-unstable
RUN deb https://ppa.launchpadcontent.net/ubuntugis/ubuntugis-unstable/ubuntu noble main 
RUN deb-src https://ppa.launchpadcontent.net/ubuntugis/ubuntugis-unstable/ubuntu noble main 
RUN apt-get update
RUN apt-get update -y && apt-get install -y libgdal-dev libgeos-dev libproj-dev && \
    apt-get clean all

SHELL ["/bin/bash", "-c"]
ADD . /
RUN ["chmod", "+x", "/scripts/install_cran_packages_r.sh"]
RUN /scripts/install_cran_packages_r.sh

ENV PATH=/opt/conda/bin:$PATH