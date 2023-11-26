#!/bin/bash

# Check if the issue number is provided
if [ -z "$1" ]
then
  echo "Error: No issue number provided."
  exit 1
fi

# Assign the issue number to a variable
ISSUE_NUMBER=$1

# Fetch the issue data using GitHub CLI and save it in markdown format
gh issue view "$ISSUE_NUMBER" --json title,body,comments -t '{{.title}}|{{.body}}{{range .comments}}|{{.body}}{{end}}' > "issue_${ISSUE_NUMBER}.md"

