#!/bin/bash

# Environment Variables
OPENAI_API_KEY=$1
GH_TOKEN=$2
ISSUE_NUMBER=$3
LABEL_NAME=$4

function executeScript {
    local script_url=$1
    shift
    local script_name=$(basename "$script_url")

    # Fetch and execute the script with any additional arguments
    curl -s "$script_url" > "$script_name" && chmod +x "$script_name" && ./"$script_name" "$@"
}

function handleBlog {
    executeScript "https://raw.githubusercontent.com/neuralmesh/apimesh/main/issueblogger.sh" "$ISSUE_NUMBER"
}

function handleTaskRouter {
    executeScript "https://raw.githubusercontent.com/neuralmesh/apimesh/main/taskrouter.sh"
}

function handleComment {
    executeScript "https://raw.githubusercontent.com/neuralmesh/apimesh/main/issuecommenter.sh" "$OPENAI_API_KEY" "$GH_TOKEN" "$ISSUE_NUMBER"
}

# Main
case "$LABEL_NAME" in
  "comment")
    handleComment
    ;;
  "blog")
    handleBlog
    ;;
  "taskrouter")
    handleTaskRouter
    ;;
  *)
    echo "No matching handler for label: $LABEL_NAME"
    ;;
esac

