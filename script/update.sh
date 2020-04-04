#!/bin/bash

has(){
	type ${1} > /dev/null 2>&1
	return $?
}

error(){
	echo "${1}"
	return 1
}

has "gsed" || error "gsed not installed"
has "git" || error "git not installed"
has "gh" || error "gh not installed"

[ -n "${GITHUB_TOKEN}" ] || error "GITHUB_TOKEN is empty"

git tag -l | tail -n 1 | sed -e 's/^v//' | tee VERSION

HUGO_VERSION=$(curl -s \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: token ${GITHUB_TOKEN}" \
    https://api.github.com/repos/gohugoio/hugo/releases/latest \
    | jq -r .tag_name | sed -e 's/^v//')
CURRENT=$(cat VERSION)

echo "       Latest Hugo version: ${HUGO_VERSION}"
echo "Current Build Hugo version: ${CURRENT}"

[ "${HUGO_VERSION}" == "${CURRENT}" ] && exit 0

read -p "Proceed to open a pull request to bump to ${HUGO_VERSION}? (y/N): " yn
case "${yn}" in
    [yY]*) : ;;
    *) exit 0;;
esac

git co -b "update/${HUGO_VERSION}"
gsed -i "s/${CURRENT}/${HUGO_VERSION}/g" Dockerfile README.md VERSION
git add Dockerfile README.md VERSION
git commit -a \
    -m "Update to ${HUGO_VERSION}" \
    -m "Updating Hugo to [v${HUGO_VERSION}](https://github.com/gohugoio/hugo/releases/tag/v${HUGO_VERSION})" 
gh pr create -f 
