#!/bin/bash

git checkout main
git pull
git tag -a "v$(cat VERSION)" -m "Update to v$(cat VERSION)"
git push origin --tags
