# docker run --rm httpd:2.4 cat /usr/local/apache2/conf/httpd.conf > my-httpd.conf

FROM httpd:2.4

RUN apt-get update && apt-get install -y python3
COPY ./proxy-httpd.conf /usr/local/apache2/conf/httpd.conf
COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
