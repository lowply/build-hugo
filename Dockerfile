FROM debian:9-slim
RUN apt-get update -y && apt-get install ca-certificates -y
RUN update-ca-certificates
ADD https://github.com/gohugoio/hugo/releases/download/v0.55.6/hugo_extended_0.55.6_Linux-64bit.deb /usr/local/src
RUN dpkg -i /usr/local/src/hugo_extended_0.55.6_Linux-64bit.deb
ENTRYPOINT hugo
