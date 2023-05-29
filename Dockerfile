FROM debian:buster-slim
RUN apt-get update -y && apt-get install ca-certificates -y
RUN update-ca-certificates
ADD https://github.com/gohugoio/hugo/releases/download/v0.112.4/hugo_extended_0.112.4_linux-amd64.deb /tmp
RUN dpkg -i /tmp/hugo_extended_0.112.4_linux-amd64.deb
ENTRYPOINT ["hugo"]
