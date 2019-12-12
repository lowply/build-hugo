# Build Hugo

A GitHub Action to build [Hugo](https://gohugo.io/) site.

- Using [Hugo extended version 0.61.0](https://github.com/gohugoio/hugo/releases/tag/v0.61.0)
- Using [debian:buster-slim](https://hub.docker.com/_/debian/) as the base image

### Example workflow

```
name: Build Hugo
on: [push]
jobs:
  build:
    name: Build
    runs-on: ubuntu-latest
    steps:
    - name: Check out code
      uses: actions/checkout@master
    - name: Build Hugo
      uses: lowply/build-hugo@v0.61.0
```

### Running it locally

```
docker run --rm -w /tmp -v $(pwd):/tmp lowply/build-hugo:v0.61.0
```
