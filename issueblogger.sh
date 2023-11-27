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
      "content": "You are a helpful assistant. Reformat the following GitHub issue content into a concise markdown format suitable for about 4 tweets, focusing on how it will help the project succeed in helping users develop new tools that specialize in improving developer experience. Your main goal is to have the highest possible information/token ratio possible. And make sure you respond in a nice and professional concise neutral tone. Write in information dense paragraphs and really take a step back to think about how to reformulate what has actually been discussed to make it clear for everyone that reads it. Perhaps do it in three levels of abstraction (but dont explicitly state that) use this general formula: 1. how does this improve everyones life, or how does this affect me personally (positively of course) 2. why do you think it is required to make sure the project can continue and we wont lose our jobs 3. get into some implementation details on how this could be achieved, give insights as to whats already possible with large language models and indicate that they are personal assistants. Okay i think you get my point. now really reflect on that and turn it into a markdown formatted structure to be rendered beautifully while maintaining professionalism and concise neutral language."
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
