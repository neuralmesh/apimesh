#!/bin/bash

# Check if the issue number is provided
if [ -z "$1" ]
then
  echo "Error: No issue number provided." >&2
  exit 1
fi

# Assign the issue number to a variable
ISSUE_NUMBER=$1

mkdir -p blog

# Fetch the issue data using GitHub CLI and store it in a variable
ISSUE_CONTENT=$(gh issue view "$ISSUE_NUMBER" --json title,body,comments -t '{{.title}}|{{.body}}{{range .comments}}|{{.body}}{{end}}')

# Ensure your OpenAI API key is set in the environment variable
if [ -z "$OPENAI_API_KEY" ]
then
  echo "Error: OPENAI_API_KEY is not set." >&2
  exit 1
fi

# Make a request to the OpenAI API using curl
RESPONSE=$(curl -s "https://api.openai.com/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d @- <<EOF
{
  "model": "gpt-4",
  "messages": [
    {
      "role": "system",
      "content": "You are a helpful assistant. Reformat the following GitHub issue content into a concise markdown format suitable for about 4 tweets, focusing on how it will help the project succeed in helping users develop new tools that specialize in improving developer experience. Your main goal is to have the highest possible information/token ratio possible."
    },
    {
      "role": "user",
      "content": "$ISSUE_CONTENT"
    }
  ]
}
EOF
)

CONTENT=$(echo "$RESPONSE" | jq -r '.choices[0].message.content')
METADATA=$(echo "$RESPONSE" | jq '{id: .id, model: .model, created: .created}')

# Write the metadata and content to a markdown file
{
  echo "---"
  echo "$METADATA" | yq e -P -  # Convert JSON metadata to YAML
  echo "---"
  echo "$CONTENT"
} > "blog/issue_${ISSUE_NUMBER}.md"
