FROM debian:bookworm-slim
RUN apt-get update -y && apt-get install ca-certificates -y
RUN update-ca-certificates
ADD https://github.com/gohugoio/hugo/releases/download/v0.152.0/hugo_extended_0.152.0_linux-amd64.deb /tmp
RUN dpkg -i /tmp/hugo_extended_0.152.0_linux-amd64.deb
ENTRYPOINT ["hugo"]
