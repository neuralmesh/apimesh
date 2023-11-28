#!/bin/bash

# Check if issue number, GH_TOKEN, and OPENAI_API_KEY are set
[ -z "$1" ] && echo "Error: Issue number is not provided." && exit 1
[ -z "$GH_TOKEN" ] && echo "Error: GH_TOKEN environment variable is not set." && exit 1
[ -z "$OPENAI_API_KEY" ] && echo "Error: OPENAI_API_KEY environment variable is not set." && exit 1

ISSUE_NUMBER=$1

# Function to install Python dependencies
install_python_dependencies() {
    echo "Installing Python Dependencies..."
    pip install fastapi pydantic langchain openai
}

# Function to fetch issue data
fetch_issue_data() {
    echo "Fetching Issue Data for Issue Number: $ISSUE_NUMBER"
    bash ./issuefetcher.sh "$ISSUE_NUMBER"
}

# Function to run the Apimesh Python script
run_apimesh() {
    echo "Running Apimesh Python Script..."
    python ./apimesh.py "$(cat issue_$ISSUE_NUMBER.md)"
}

# Function to authenticate with GitHub CLI
authenticate_gh_cli() {
    echo "Authenticating GitHub CLI..."
    echo "$GH_TOKEN" | gh auth login --with-token
}

# Function to post AI response as a comment
post_ai_response() {
    echo "Posting AI Response as Comment..."
    gh issue comment "$ISSUE_NUMBER" --body "$(cat ai_response.txt)"
    gh issue edit "$ISSUE_NUMBER" --remove-label "apimesh"
}

# Main execution
install_python_dependencies
fetch_issue_data
run_apimesh
authenticate_gh_cli
post_ai_response

