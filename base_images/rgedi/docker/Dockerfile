FROM continuumio/miniconda3:4.12.0

# install maap-py library
ENV MAAP_CONF='/maap-py/'
RUN git clone --single-branch --branch v3.1.2 https://github.com/MAAP-Project/maap-py.git \
    && cd maap-py \
    && pip install -e .

RUN mkdir /projects
WORKDIR /projects
RUN sed -i -e 's/\/root/\/projects/g' /etc/passwd && echo "source activate r-with-gdal" > ~/.bashrc
RUN apt-get update && apt-get install -y libxt-dev && apt-get clean

RUN conda install -y -c conda-forge pyOpenSSL=23.2.0 && \
    conda install -y -n base conda-libmamba-solver=23.7.0 && \
    conda config --set solver libmamba

RUN conda install -y --solver=libmamba -c conda-forge nb_conda_kernels

RUN conda create --name r-with-gdal --solver=libmamba -c conda-forge -c r -c csdms-stack gdal r-rgdal r-sf r-irkernel r-gridExtra r-tidyverse \
    r-randomForest r-raster r-data.table r-rlist r-gdalutils r-stringr r-devtools sysroot_linux-64=2.17 gcc r-lwgeom szip --yes && \
    /opt/conda/bin/conda clean -afy
RUN mkdir -p ~/.R/ && echo "LDFLAGS=-lproj" >> ~/.R/Makevars && \
    conda run --no-capture-output -n r-with-gdal Rscript -e "devtools::install_git('https://github.com/carlos-alberto-silva/rGEDI', dependencies=TRUE)"

ARG IMAGE_REF
ENV DOCKERIMAGE_PATH=${IMAGE_REF}
