#!/bin/bash

# Exit if any command fails
set -e

# Check required environment variables
required_env_vars=("GH_TOKEN" "OPENAI_API_KEY" "ISSUE_NUMBER")
for var in "${required_env_vars[@]}"; do
    if [ -z "${!var}" ]; then 
        echo "Error: $var environment variable is not set."
        exit 1
    fi
done

# Install Python dependencies
echo "Installing Python Dependencies..."
pip install fastapi pydantic langchain openai

# Fetch issue data and run Apimesh Python script
echo "Fetching Issue Data for Issue Number: $ISSUE_NUMBER"
bash ./issuefetcher.sh "$ISSUE_NUMBER"

echo "Running Apimesh Python Script..."
python ./apimesh.py "$(cat issue_$ISSUE_NUMBER.md)"

# Authenticate with GitHub CLI and post AI response as a comment
echo "Authenticating GitHub CLI..."
echo "$GH_TOKEN" | gh auth login --with-token

echo "Posting AI Response as Comment..."
gh issue comment "$ISSUE_NUMBER" --body "$(cat ai_response.txt)"
gh issue edit "$ISSUE_NUMBER" --remove-label "apimesh"

