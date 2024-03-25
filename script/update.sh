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
if [ -z "${GITHUB_ACTIONS}" ]; then
    sed -i '' "s/${CURRENT}/${LATEST}/g" ${FILES} # macOS
    ./script/pr.sh ${LATEST}
else
    sed -i "s/${CURRENT}/${LATEST}/g" ${FILES} # Linux / Actions Runner
    echo "update=true" >> $GITHUB_OUTPUT
fi
