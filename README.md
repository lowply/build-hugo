# Build Hugo

A GitHub Action to build Hugo site.

- Using [Hugo extended version 0.54](https://github.com/gohugoio/hugo/releases/tag/v0.54.0)
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
