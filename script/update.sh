#!/bin/bash

has(){
    type ${1} > /dev/null 2>&1
    return $?
}

error(){
    echo "${1}"
    exit 1
}

REQUIRED=""
has "gsed" || REQUIRED="${REQUIRED} gsed"
has "git" || REQUIRED="${REQUIRED} git"
has "gh" || REQUIRED="${REQUIRED} gh"
has "jq" || REQUIRED="${REQUIRED} jq"
[ -z "${REQUIRED}" ] || error "Some tools are not installed:${REQUIRED}"
[ -n "${GITHUB_TOKEN}" ] || error "GITHUB_TOKEN is empty"
[ "$(git branch --show-current)" == 'master' ] || error "Check out the master branch first."

HUGO_VERSION=$(curl -s \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: token ${GITHUB_TOKEN}" \
    https://api.github.com/repos/gohugoio/hugo/releases/latest \
    | jq -r .tag_name | sed -e 's/^v//')
CURRENT=$(git tag -l | tail -n 1 | sed -e 's/^v//')

echo "       Latest Hugo version: ${HUGO_VERSION}"
echo "Current Build Hugo version: ${CURRENT}"

[ "${HUGO_VERSION}" == "${CURRENT}" ] && error "No need to update."

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
