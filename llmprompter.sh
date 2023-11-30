#!/bin/bash

# Sends a string to an llm endpoint
# receives a response for any question or inquiry
# could contain text, commands, files, ideas

# Exit if any command fails
set -e

# Check for required arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <system_message> <user_message>"
    exit 1
fi

bash ./envtester.sh OPENAI_API_KEY MODEL_LLM

SYSTEM_MESSAGE=$1
USER_MESSAGE=$2

# Make a request to the OpenAI API using curl
RESPONSE=$(curl -s "https://api.openai.com/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d @- <<EOF
{
  "model": "$MODEL_LLM",
  "messages": [
    {
      "role": "system",
      "content": "$SYSTEM_MESSAGE"
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

# Print the metadata and content
echo "---"
echo "$METADATA" | yq e -P -
echo "Issue $ISSUE_NUMBER"
echo "---"
echo "$CONTENT"

