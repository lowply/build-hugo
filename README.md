# Build Hugo

A GitHub Action to build [Hugo](https://gohugo.io/) site.

- Using [Hugo extended version 0.69.0](https://github.com/gohugoio/hugo/releases/tag/v0.69.0)
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
      uses: lowply/build-hugo@v0.69.0
```

### Running it locally

```
docker run --rm -w /tmp -v $(pwd):/tmp lowply/build-hugo:v0.69.0
```

### Catch up with Hugo version

Run:

```
./script/update.sh
```

Review the PR and make sure it passes the test.

### Deployment

After merging the update PR, run:

```
git checkout master && git pull && git tag "v$(cat VERSION)" && git push origin --tags
```