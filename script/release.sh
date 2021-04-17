#!/bin/bash

git checkout master
git pull
git tag -a "v$(cat VERSION)" -m "Update to v$(cat VERSION)"
git push origin --tags
