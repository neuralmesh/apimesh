#!/bin/bash

# Exit if any command fails
set -e

# Check required environment variables
required_env_vars=("BRANCH_NAME" "GITHUB_TOKEN")
for var in "${required_env_vars[@]}"; do
    if [ -z "${!var}" ]; then 
        echo "Error: $var environment variable is not set."
        exit 1
    fi
done


# Title and body for the pull request
PR_TITLE="Pull Request for ${BRANCH_NAME}"
PR_BODY="This is an automated pull request for branch ${BRANCH_NAME}."

# Create the pull request using the GITHUB_TOKEN provided by GitHub Actions
gh pr create --title "$PR_TITLE" --body "$PR_BODY" --head "$BRANCH_NAME"

