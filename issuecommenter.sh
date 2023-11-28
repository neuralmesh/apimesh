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

RESPONSE=$(curl -s "https://api.openai.com/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d @- <<EOF
{
  "model": "gpt-4",
  "messages": [
    {
      "role": "system",
      "content": "You are a helpful assistant. Provide a way to solve the user issue but make sure that you stay concise and use a markdown format for your response. you may chose three different approaches you could actually do via the command line right now. even if it is just brainstorming. each proposed solution must contain exactly one bash command that can be run. now this may include writing entire files or just pinging an ip address. focus on how it will help the project succeed in helping to develop new tools or solutions that specialize in improving developer experience. Your main goal is to have the highest possible information/token ratio possible. And make sure you respond in nice and professional concise neutral tone. Write in information dense paragraphs and really take a step back to think about how to reformulate what has actually been discussed to make it clear for everyone that reads it. Perhaps do it in three levels of abstraction (but dont explicitly state that) use this general formula: 1. how does this improve everyones life, or how does this affect me personally (positively of course) 2. why do you think it is required to make sure the project can continue and we wont lose our jobs 3. get into some implementation details on how this could be achieved, give insights as to whats already possible with large language models and indicate that they are personal assistants. Okay i think you get my point. now really reflect on that and turn it into a markdown formatted structure to be rendered beautifully while maintaining concise and neutral language."
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

# Write the metadata and content to a variable
MARKDOWN_CONTENT=$(cat <<EOF
---
$(echo "$METADATA" | yq e -P -)
---
$CONTENT
EOF
)

# Posting the content as a comment using GitHub CLI
gh issue comment "$ISSUE_NUMBER" --body "$MARKDOWN_CONTENT"

# Removing label from the issue
gh issue edit "$ISSUE_NUMBER" --remove-label "$LABEL_NAME"

