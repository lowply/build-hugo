# Build Hugo

A GitHub Action to build [Hugo](https://gohugo.io/) site.

- Using [Hugo extended version 0.72.0](https://github.com/gohugoio/hugo/releases/tag/v0.72.0)
- Using [debian:buster-slim](https://hub.docker.com/_/debian/) as the base image

## Usage

### Example workflow

```yaml
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
      uses: lowply/build-hugo@v0.72.0
```

### Versioning

Build Hugo version is designed to match with [the Hugo's version](https://github.com/gohugoio/hugo/releases). If you'd like to use a specific version of Hugo to build your website, do it like this:

```yaml
    - name: Build Hugo
      uses: lowply/build-hugo@v0.68.3
```

### Running it locally

```
docker run --rm -w /tmp -v $(pwd):/tmp lowply/build-hugo:v0.72.0
```

## Development

### Catching up with the latest Hugo version

Run this to create a PR:

```
./script/update.sh
```

Review the PR and make sure it passes the test. After merging the update PR, run:

```
./script/release.sh
```
