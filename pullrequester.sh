#!/bin/bash

# Exit if any command fails
set -e

# Check required environment variables
required_env_vars=("BRANCH_NAME" "GITHUB_TOKEN" "GITHUB_REPOSITORY")
for var in "${required_env_vars[@]}"; do
    if [ -z "${!var}" ]; then 
        echo "Error: $var environment variable is not set."
        exit 1
    fi
done

# Configure Git user identity
git config --global user.email "action@github.com"
git config --global user.name "GitHub Action"

# Create and checkout the new branch
git checkout -b "$BRANCH_NAME"

# Title and body for the pull request
PR_TITLE="Pull Request for ${BRANCH_NAME}"
PR_BODY="This is an automated pull request for branch ${BRANCH_NAME}."

git add .
git commit -m "Automated commit for ${BRANCH_NAME}"

# Set up remote URL with authentication token
GIT_REMOTE_URL="https://x-access-token:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
git remote set-url origin "${GIT_REMOTE_URL}"

# Push the changes
git push --force --set-upstream origin "$BRANCH_NAME"

# Create the pull request using the GITHUB_TOKEN provided by GitHub Actions
gh pr create --title "$PR_TITLE" --body "$PR_BODY" --head "$BRANCH_NAME"

