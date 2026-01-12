# Build Hugo

A GitHub Action for building [Hugo](https://gohugo.io/) sites.

- Utilizes [Hugo extended version 0.154.4](https://github.com/gohugoio/hugo/releases/tag/v0.154.4)
- Based on [debian:bookworm-slim](https://hub.docker.com/_/debian/)

## Usage

### Example Workflow

```yaml
name: Build Hugo
on: [push]
jobs:
  build:
    name: Build
    runs-on: ubuntu-latest
    steps:
    - name: Check out code
      uses: actions/checkout@v2
    - name: Build Hugo
      uses: lowply/build-hugo@v0.154.4
```

### Versioning

The Build Hugo version aligns with [Hugo's releases](https://github.com/gohugoio/hugo/releases). If you need a specific Hugo version to build your website, you can specify it like this:

```yaml
    - name: Build Hugo
      uses: lowply/build-hugo@v0.68.3
```

> [!WARNING]
> As of recently the mirrors for [debian:buster-slim](https://hub.docker.com/_/debian/) are broken. Therefore this action will not work for the versions that reference that base image. A current workaround is to use 0.148.1 or later which uses the `debian:bookworm-slim` base image.

### Running Locally

To run it locally, use the following command:

```
docker run --rm -w /tmp -v $(pwd):/tmp lowply/build-hugo:v0.154.4
```

## Development

### Keeping Up with the Latest Hugo Version

To create a PR for the latest version, run:

```
./script/update.sh
```

After reviewing and ensuring the PR passes all tests, merge it, and then execute:

```
./script/release.sh
```
