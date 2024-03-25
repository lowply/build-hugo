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

LATEST=$(gh api repos/gohugoio/hugo/releases/latest | jq -r .tag_name | sed -e 's/^v//')
CURRENT=$(cat VERSION)

if [ "${LATEST}" = "${CURRENT}" ]; then
    [ -z "${GITHUB_ACTIONS}" ] && echo "Already up-to-date."
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

git checkout -b "update/${LATEST}"
if [ -z "${GITHUB_ACTIONS}" ]; then
    # macOS
    sed -i '' "s/${CURRENT}/${LATEST}/g" ${FILES}
else
    # Linux / Actions Runner
    sed -i "s/${CURRENT}/${LATEST}/g" ${FILES}
fi
git add ${FILES}
git commit -a \
    -m "Update to ${LATEST}" \
    -m "Updating Hugo to [v${LATEST}](https://github.com/gohugoio/hugo/releases/tag/v${LATEST})"
git push origin "update/${LATEST}"
gh pr create -f
