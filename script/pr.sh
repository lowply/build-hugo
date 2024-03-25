#!/bin/bash

LATEST=${1}
git checkout -b "update/${LATEST}"
git add .
git commit -a \
    -m "Update to ${LATEST}" \
    -m "Updating Hugo to [v${LATEST}](https://github.com/gohugoio/hugo/releases/tag/v${LATEST})"
git push origin "update/${LATEST}"
gh pr create -f
