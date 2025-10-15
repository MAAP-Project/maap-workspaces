FROM rocker/binder:4

USER root

# 3. Use the system package manager (apt-get) to install Python, pip, and dev tools.
# Chaining commands reduces image layers. Cleaning up afterwards keeps the image smaller.
RUN apt-get update && \
    apt-get install -y python3 python3-pip python3-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# TODO install missing R packages 

# Install maap specific python packages
COPY ./requirements.txt .
RUN pip install --break-system-packages --no-cache-dir -r requirements.txt

# TODO is this the user to set back to??
USER rstudio
CMD ["jupyter-labhub"]