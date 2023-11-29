#!/bin/bash

# Check if the issue number is provided
if [ -z "$ISSUE_NUMBER" ]
then
  echo "Error: No ISSUE_NUMBER env var found."
  exit 1
fi

# Define a Go template for Markdown formatting
TEMPLATE='
{{- printf "# %s\n\n" .title -}}
{{- .body -}}

{{- if .comments -}}
  {{- range $index, $comment := .comments -}}
    {{- printf "\n#### Comment %d\n\n" $index -}}
    {{- $comment.body -}}
  {{- end -}}
{{- end -}}
'

# Fetch the issue data using GitHub CLI with the custom template
gh issue view "$ISSUE_NUMBER" --json title,body,comments --template "$TEMPLATE"

