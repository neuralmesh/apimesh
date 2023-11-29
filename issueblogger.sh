#!/bin/bash

# Exit if any command fails
set -e

# Check required environment variables
bash envtester.sh OPENAI_API_KEY ISSUE_NUMBER MODEL_LLM

ISSUE_CONTENT=$(bash ./issuefetcher.sh)

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
      "content": "You are a helpful assistant. Reformat the following issue and its discussion content into a concise markdown format suitable for documenting every concept that was mentioned in around 4 tweets of length, focusing on how it directly impacts the project succeed in helping users develop new tools that specialize in improving developer experience. Your main goal is to have the highest possible information/token ratio possible. And make sure you respond in a nice concise neutral tone. Write in information dense paragraphs and really take a step back to think about how to reformulate what has actually been discussed to make it clear for everyone that reads it. Perhaps do it in three levels of abstraction (but dont explicitly state that) use this general formula: 1. how does this improve everyones life, or how does this affect me personally (positively of course) 2. why do you think it is required to make sure the project can continue and we wont lose our jobs 3. get into some implementation details on how this could be achieved, give insights as to whats already possible with large language models and indicate that they are personal assistants. Okay i think you get my point. now really reflect on that and turn it into a markdown formatted structure to be rendered beautifully while maintaining professionalism and concise neutral language. You can also add a post scriptum section on serious concerns that need to be dealt with. In the past you used way too many superfluous adjectives. your goal is not to manipulate people into using your proposals but to let them interpret the facts themselves. you just need to really make the point as to why it could be useful. and be concise dont waste text space."
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

# Set and export BRANCH_NAME as an environment variable
export BRANCH_NAME="blog-issue-${ISSUE_NUMBER}"

gh issue edit "$ISSUE_NUMBER" --remove-label "$LABEL_NAME"

bash ./pullrequester.sh

