#!/bin/bash

git checkout master
git pull
git tag "v$(cat VERSION)"
git push origin --tags
