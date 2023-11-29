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
      "content": "Your task is to convert a discussion into a Markdown document, with an emphasis on effectively encapsulating all critical concepts. Your writing should be neutral and concise, prioritizing clarity, relevance, and a high information-to-token ratio.

Overview: Start by outlining the overall impact of the issue on the audience, highlighting positive outcomes and personal relevance.

Project Significance: Detail the importance of addressing this issue for the project's sustainability and job security.

Implementation Insights: Provide in-depth analysis on practical implementation strategies, utilizing insights from large language models as personal assistants. Incorporate relevant code snippets and actionable insights that offer real value.

Guidelines: Strive for an information-rich content approach, steering clear of unnecessary language. Aim to deliver factual information that empowers readers to independently evaluate the merits of your proposals.

Postscriptum: End with a segment addressing any significant concerns or challenges that merit attention.

The goal is to craft a clear, professional, and well-organized Markdown document, enabling readers to quickly comprehend the core of the discussion. Include code examples or intriguing concepts where applicable to enhance practical understanding and application."
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
  echo "Issue $ISSUE_NUMBER"
  echo "---"
  echo "$CONTENT"
} > "blog/issue_${ISSUE_NUMBER}.md"

# Set and export BRANCH_NAME as an environment variable
export BRANCH_NAME="blog-issue-${ISSUE_NUMBER}"

gh issue edit "$ISSUE_NUMBER" --remove-label "$LABEL_NAME"

bash ./pullrequester.sh

