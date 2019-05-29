FROM debian:9-slim

LABEL "com.github.actions.name"="Build Hugo"
LABEL "com.github.actions.description"="Build Hugo"
LABEL "com.github.actions.icon"="code"
LABEL "com.github.actions.color"="purple"
LABEL "repository"="https://github.com/lowply/build-hugo"
LABEL "homepage"="https://github.com/lowply"
LABEL "maintainer"="Sho Mizutani <lowply@github.com>"

RUN apt-get update -y && apt-get install ca-certificates -y
RUN update-ca-certificates

ADD https://github.com/gohugoio/hugo/releases/download/v0.55.6/hugo_extended_0.55.6_Linux-64bit.deb /usr/local/src
RUN dpkg -i /usr/local/src/hugo_extended_0.55.6_Linux-64bit.deb
