#!/bin/bash

# Environment Variables
OPENAI_API_KEY=$1
GH_TOKEN=$2
ISSUE_NUMBER=$3
LABEL_NAME=$4

# Function to handle "blog" label
function handleBlog {
  # Fetch the issueblogger script
  curl -s https://raw.githubusercontent.com/neuralmesh/apimesh/main/issueblogger.sh > issueblogger.sh
  chmod +x issueblogger.sh
  ./issueblogger.sh $ISSUE_NUMBER
}

# Function to handle other tasks, e.g., "taskrouter"
function handleTaskRouter {
  # Fetch the taskrouter script
  curl -s https://raw.githubusercontent.com/neuralmesh/apimesh/main/taskrouter.sh > taskrouter.sh
  chmod +x taskrouter.sh
  ./taskrouter.sh
}

# Main
case "$LABEL_NAME" in
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

