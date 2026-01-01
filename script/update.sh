#!/bin/bash

set -euo pipefail

BASE_BRANCH="${BASE_BRANCH:-main}"
REMOTE_NAME="${REMOTE_NAME:-origin}"
# Default branch prefix aligns with existing naming like update/0.152.2.
# Set BRANCH_PREFIX=update/v to include the leading "v" if you prefer.
BRANCH_PREFIX="${BRANCH_PREFIX:-update}"

has() {
    type "$1" >/dev/null 2>&1
}

error() {
    echo "$1" >&2
    exit 1
}

if [ -z "${GITHUB_ACTIONS:-}" ]; then
    REQUIRED=()
    has "git" || REQUIRED+=("git")
    has "gh" || REQUIRED+=("gh")
    has "jq" || REQUIRED+=("jq")
    if [ "${#REQUIRED[@]}" -ne 0 ]; then
        error "Missing required tools: ${REQUIRED[*]}"
    fi

    CURRENT_BRANCH="$(git branch --show-current)"
    [ "${CURRENT_BRANCH}" = "${BASE_BRANCH}" ] || error "Check out the ${BASE_BRANCH} branch first."
else
    git config user.email "sho@svifa.net"
    git config user.name "Sho Mizutani"
fi

LATEST_TAG="$(gh release list --repo gohugoio/hugo --exclude-drafts --exclude-pre-releases --json tagName,isLatest -q '.[] | select(.isLatest == true) | .tagName')"
LATEST="${LATEST_TAG#v}"
CURRENT="$(cat VERSION)"

if [ -z "${LATEST}" ]; then
    error "Failed to get Hugo's latest version."
fi

if [ "${LATEST}" = "${CURRENT}" ]; then
    echo "Already up-to-date."
    exit 0
fi

BRANCH_NAME="${BRANCH_PREFIX}/${LATEST}"

if [ "$(gh pr list --head "${BRANCH_NAME}" --json number -q 'length')" != "0" ]; then
    echo "Pull request already exists."
    exit 0
fi

echo "Build Hugo version: v${CURRENT}"
echo "      Hugo version: v${LATEST}"

git fetch "${REMOTE_NAME}" --prune >/dev/null 2>&1

# Check for existing catch up PRs and base on the latest one if found
LATEST_CATCHUP_BRANCH="$(gh pr list -l catchup --state open --json headRefName -q 'first | .headRefName')"

if [ -n "${LATEST_CATCHUP_BRANCH}" ]; then
    BASE_REF="${LATEST_CATCHUP_BRANCH}"
    echo "Found existing catch up branch: ${LATEST_CATCHUP_BRANCH}"
    echo "Basing ${BRANCH_NAME} on ${LATEST_CATCHUP_BRANCH}."
else
    BASE_REF="${BASE_BRANCH}"
    echo "Basing ${BRANCH_NAME} on ${BASE_BRANCH}."
fi

git checkout -B "${BRANCH_NAME}" "${REMOTE_NAME}/${BASE_REF}"

FILES=(Dockerfile README.md VERSION)
for file in "${FILES[@]}"; do
    if [ "$(uname -s)" = "Darwin" ]; then
        sed -i '' "s/${CURRENT}/${LATEST}/g" "${file}"
    else
        sed -i "s/${CURRENT}/${LATEST}/g" "${file}"
    fi
done

if git diff --quiet --exit-code -- "${FILES[@]}"; then
    echo "No changes detected after attempting to bump versions."
    exit 0
fi

git add "${FILES[@]}"
git commit \
    -m "Update to ${LATEST}" \
    -m "Updating Hugo to [v${LATEST}](https://github.com/gohugoio/hugo/releases/tag/v${LATEST})"


if [ -z "${GITHUB_ACTIONS:-}" ]; then
    read -r -p "Proceed to open a pull request to bump to v${LATEST}? (y/N): " yn
    case "${yn}" in
        [yY]*);; # proceed
        *) exit 0 ;;
    esac
fi

git push --force-with-lease "${REMOTE_NAME}" "${BRANCH_NAME}"
gh pr create --base "${BASE_REF}" --head "${BRANCH_NAME}" --label catchup -f
