FROM ubuntu:20.04
RUN apt-get update && DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get install -y git npm
RUN git clone https://github.com/MAAP-Project/maap-edav-esa-front.git
WORKDIR "/maap-edav-esa-front"
RUN npm install 
RUN npm run build
COPY discovery.json /maap-edav-esa-front/dist/data/

FROM nginx:1.23.1
RUN apt-get update && apt-get install -y python3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
COPY --from=0 /maap-edav-esa-front/dist/ /usr/share/nginx/html

COPY entrypoint.sh /
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
# below is copied from nginx's Dockerfile
EXPOSE 3100

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]
