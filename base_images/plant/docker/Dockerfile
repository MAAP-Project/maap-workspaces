FROM continuumio/miniconda3:4.10.3p1

ARG IMAGE_REF

RUN mkdir /projects
WORKDIR /projects
RUN sed -i -e 's/\/root/\/projects/g' /etc/passwd

RUN conda init && conda install --no-update-deps conda-build -y
RUN conda install -c plant plant

# install maap-py library
ENV MAAP_CONF='/maap-py/'
RUN git clone --single-branch --branch master https://github.com/MAAP-Project/maap-py.git \
    && cd maap-py \
    && pip install -e .

ENV DOCKERIMAGE_PATH=${IMAGE_REF}
RUN find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy
