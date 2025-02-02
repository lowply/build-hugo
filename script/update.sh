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

if [ -z "${GITHUB_ACTIONS}" ]; then
    REQUIRED=""
    has "git" || REQUIRED="${REQUIRED} git"
    has "gh" || REQUIRED="${REQUIRED} gh"
    has "jq" || REQUIRED="${REQUIRED} jq"
    [ -z "${REQUIRED}" ] || error "Some tools are not installed:${REQUIRED}"
    [ "$(git branch --show-current)" = "main" ] || error "Check out the main branch first."
fi

LATEST=$(gh release list --repo gohugoio/hugo --exclude-drafts --exclude-pre-releases --json tagName,isLatest -q '.[] | select(.isLatest == true) | .tagName' | cut -d 'v' -f 2)
CURRENT=$(cat VERSION)

[ -z "${LATEST}" ] && { echo "Failed to get Hugo's latest version."; exit 1; }

if [ "${LATEST}" = "${CURRENT}" ]; then
    echo "Already up-to-date."
    exit 0
fi

if [ $(gh pr list --head "update/${LATEST}" --json title -q '. | length') != 0 ]; then
    echo "Pull request already exists."
    exit 0
fi

echo "Build Hugo version: ${CURRENT}"
echo "      Hugo version: ${LATEST}"

if [ -z "${GITHUB_ACTIONS}" ]; then
    read -p "Proceed to open a pull request to bump to ${LATEST}? (y/N): " yn
    case "${yn}" in
        [yY]*) : ;;
        *) exit 0;;
    esac
fi

FILES="Dockerfile README.md VERSION"
if [ -z "${GITHUB_ACTIONS}" ]; then
    sed -i '' "s/${CURRENT}/${LATEST}/g" ${FILES} # macOS
else
    sed -i "s/${CURRENT}/${LATEST}/g" ${FILES} # Linux / Actions Runner
    git config user.email "sho@svifa.net"
    git config user.name "Sho Mizutani"
fi

git checkout -b "update/${LATEST}"
git add .
git commit -a \
    -m "Update to ${LATEST}" \
    -m "Updating Hugo to [v${LATEST}](https://github.com/gohugoio/hugo/releases/tag/v${LATEST})"
gh pr create -f
