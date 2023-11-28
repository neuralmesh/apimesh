#!/bin/bash

# Debug: Echoing starting message
echo "Starting script with LABEL_NAME: $LABEL_NAME"

gh repo clone neuralmesh/apimesh
cd apimesh
ls -la

# Associative array to map label names to script URLs
declare -A scriptMap
scriptMap["comment"]="./issuecommenter.sh"
scriptMap["blog"]="./issueblogger.sh"
scriptMap["taskrouter"]="./taskrouter.sh"

# Function to execute a local script
executeScript() {
    local script_path=$1
    echo "Executing script from: $script_path"
    bash "$script_path" "${@:2}"
}

# Main logic
if [[ -n "${scriptMap[$LABEL_NAME]}" ]]; then
    echo "Handling label: $LABEL_NAME"
    executeScript "${scriptMap[$LABEL_NAME]}" "$@"
else
    echo "No matching handler for label: $LABEL_NAME"
fi
