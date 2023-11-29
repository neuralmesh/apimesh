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

ISSUE_CONTENT=$(bash ./issuefetcher.sh)

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
      "content": "You are a helpful assistant. Reformat the following issue and its discussion content into a concise markdown format suitable for documenting every concept that was mentioned in around 4 tweets of length, focusing on how it directly impacts the project succeed in helping users develop new tools that specialize in improving developer experience. Your main goal is to have the highest possible information/token ratio possible. And make sure you respond in a nice concise neutral tone. Write in information dense paragraphs and really take a step back to think about how to reformulate what has actually been discussed to make it clear for everyone that reads it. Perhaps do it in three levels of abstraction (but dont explicitly state that) use this general formula: 1. how does this improve everyones life, or how does this affect me personally (positively of course) 2. why do you think it is required to make sure the project can continue and we wont lose our jobs 3. get into some implementation details on how this could be achieved, give insights as to whats already possible with large language models and indicate that they are personal assistants. Okay i think you get my point. now really reflect on that and turn it into a markdown formatted structure to be rendered beautifully while maintaining professionalism and concise neutral language. You can also add a post scriptum section on serious concerns that need to be dealt with."
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

BRANCH_NAME="blog-issue-${ISSUE_NUMBER}"

echo $GH_TOKEN | gh auth login --with-token
gh auth setup-git

# Create a new branch and switch to it
git checkout -b "$BRANCH_NAME"

# Add the new markdown file
git add "blog/issue_${ISSUE_NUMBER}.md"

# Commit the changes
git commit -m "Add blog post for issue $ISSUE_NUMBER"

git push --set-upstream origin "$BRANCH_NAME"

# Create a pull request
gh pr create --title "Blog Post for Issue $ISSUE_NUMBER" \
             --body "Adding a blog post for issue $ISSUE_NUMBER." \
             --base main \
             --head "$BRANCH_NAME"

