#!/bin/bash
# Save as push.sh and fill in your token and repo

GITHUB_USERNAME="beniamin.czaplicki@gmail.com"
GITHUB_TOKEN="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"
REPO_NAME="elk-stack"

git add .
git commit -m "${1:-Auto commit}"
git push "https://${GITHUB_USERNAME}:${GITHUB_TOKEN}@github.com/${GITHUB_USERNAME}/${REPO_NAME}.git" main

