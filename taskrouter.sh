#!/bin/bash

# Debug: Echoing starting message
echo "Starting script with LABEL_NAME: $LABEL_NAME"

# Associative array to map label names to script URLs
declare -A scriptMap
scriptMap["comment"]="https://raw.githubusercontent.com/neuralmesh/apimesh/main/issuecommenter.sh"
scriptMap["blog"]="https://raw.githubusercontent.com/neuralmesh/apimesh/main/issueblogger.sh"
scriptMap["taskrouter"]="https://raw.githubusercontent.com/neuralmesh/apimesh/main/taskrouter.sh"

# Function to execute a script from a URL
executeScript() {
    local script_url=$1
    echo "Executing script from: $script_url"
    bash <(curl -s "$script_url") "${@:2}"
}

# Main logic
if [[ -n "${scriptMap[$LABEL_NAME]}" ]]; then
    echo "Handling label: $LABEL_NAME"
    executeScript "${scriptMap[$LABEL_NAME]}" "$@"
else
    echo "No matching handler for label: $LABEL_NAME"
fi
