#!/bin/bash

set -e

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
# [ -n "${GITHUB_TOKEN}" ] || error "GITHUB_TOKEN is empty"
[ "$(git branch --show-current)" == 'main' ] || error "Check out the main branch first."

LATEST=$(gh api repos/gohugoio/hugo/releases/latest | jq -r .tag_name | sed -e 's/^v//')
CURRENT=$(cat VERSION)

echo "       Latest Hugo version: ${LATEST}"
echo "Current Build Hugo version: ${CURRENT}"

[ "${LATEST}" == "${CURRENT}" ] && error "No need to update."

read -p "Proceed to open a pull request to bump to ${LATEST}? (y/N): " yn
case "${yn}" in
    [yY]*) : ;;
    *) exit 0;;
esac

git co -b "update/${LATEST}"
gsed -i "s/${CURRENT}/${LATEST}/g" Dockerfile README.md VERSION
git add Dockerfile README.md VERSION
git commit -a \
    -m "Update to ${LATEST}" \
    -m "Updating Hugo to [v${LATEST}](https://github.com/gohugoio/hugo/releases/tag/v${LATEST})" 
git push origin "update/${LATEST}"
gh pr create -f 
