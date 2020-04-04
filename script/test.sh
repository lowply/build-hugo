#!/bin/bash

docker build . -t lowply/build-hugo
docker run --rm -w /tmp -v $(pwd)/test:/tmp lowply/build-hugo
