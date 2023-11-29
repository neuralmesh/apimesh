#!/bin/bash

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

