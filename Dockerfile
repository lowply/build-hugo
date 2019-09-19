FROM debian:buster-slim
RUN apt-get update -y && apt-get install ca-certificates -y
RUN update-ca-certificates
ADD https://github.com/gohugoio/hugo/releases/download/v0.58.2/hugo_extended_0.58.2_Linux-64bit.deb /tmp
RUN dpkg -i /tmp/hugo_extended_0.58.2_Linux-64bit.deb
ENTRYPOINT hugo
