# Build Hugo

## This action will be updated to fit the newer version of GitHub Actions on September 30, 2019.

A GitHub Action to build Hugo site.

- Using [Hugo extended version 0.55.6](https://github.com/gohugoio/hugo/releases/tag/v0.55.6)
- Using [debian:9-slim](https://hub.docker.com/_/debian/) for the base image

Example workflow

```
workflow "Build" {
  on = "push"
  resolves = ["Build Hugo"]
}

action "Build Hugo" {
  uses = "lowply/build-hugo@master"
  runs = "hugo"
}
```
