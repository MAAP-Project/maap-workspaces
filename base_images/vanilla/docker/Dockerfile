FROM continuumio/miniconda3:23.10.0-1
ENV LANG en_US.UTF-8
ENV TZ US/Pacific
ARG DEBIAN_FRONTEND=noninteractive

RUN mkdir /projects
WORKDIR /projects
RUN sed -i -e 's/\/root/\/projects/g' /etc/passwd

COPY ./environment.yml /tmp
RUN conda env create -y -f "/tmp/environment.yml" \
    && find /opt/conda/ -follow -type f -name '*.a' -delete \
    && find /opt/conda/ -follow -type f -name '*.js.map' -delete \
    && /opt/conda/bin/conda clean -afy

# Set the conda environment for all subsequent docker RUN commands
# When maap-py is updated and installed via our environment.yml,
# we won't need this line unless other envrionment specific commands are added
#SHELL ["conda", "run", "-n", "vanilla", "/bin/bash", "-c"]
#RUN which pip
# RUN ls
# RUN echo "conda activate vanilla" >> ~/.bashrc
# RUN ls
# RUN conda init bash
# RUN /bin/bash -c "source ~/.bashrc && conda install -y boto3"

# RUN conda list 
#RUN conda list
#RUN conda init bash
#RUN cat ~/.bashrc
#RUN source /opt/conda/bin/activate vanilla
#SHELL ["conda", "init"]
# RUN conda init
# RUN conda list 
# RUN conda intall -n vanilla boto3
# RUN conda list 
#RUN conda init bash
#SHELL ["/bin/bash", "-c"]
#RUN echo "conda activate vanilla" >> ~/.bashrc
#RUN echo "conda activate vanilla" >> ~/.bash_profile
SHELL ["/bin/bash", "-c"] 
RUN conda init && echo "conda activate vanilla" >> ~/.bashrc
RUN cat ~/.bashrc
#RUN cat ~/.bash_profile
#RUN source ~/.bashrc
RUN /bin/bash -c 'source activate vanilla'
#SHELL ["source", "activate", "vanilla"]

# RUN /opt/conda/envs/vanilla/bin/pip install scipy
# RUN conda install --name vanilla -y s3fs
# RUN conda list

# Install maap-py library
RUN mkdir /maap-py \
    && git clone --single-branch --branch v3.1.5 https://github.com/MAAP-Project/maap-py.git /maap-py/ \
    && /opt/conda/envs/vanilla/bin/pip install -e /maap-py/

ARG IMAGE_REF
ENV DOCKERIMAGE_PATH=${IMAGE_REF}