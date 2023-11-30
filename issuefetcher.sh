#!/bin/bash

# fetches issue content from github
# turns it into a nicely formatted markdown string and prints it to stdout to be piped somewhere
# Usage: ./issuefetcher.sh

# Check if the issue number is provided
bash envtester.sh ISSUE_NUMBER

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

