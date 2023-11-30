#!/bin/bash

# Exit if any command fails
set -e

# Check required environment variables
bash envtester.sh OPENAI_API_KEY ISSUE_NUMBER MODEL_LLM GITHUB_TOKEN

ISSUE_CONTENT=$(bash ./issuefetcher.sh)

SYSTEM_MESSAGE=$(bash ./promptbuilder.sh)

RESPONSE=$(bash ./llmprompter.sh "$SYSTEM_MESSAGE" "$ISSUE_CONTENT")

# Posting the content as a comment using GitHub CLI
gh issue comment "$ISSUE_NUMBER" --body "$RESPONSE"

# Removing label from the issue
gh issue edit "$ISSUE_NUMBER" --remove-label "$LABEL_NAME"

