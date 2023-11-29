#!/bin/bash

# This script checks if the provided environment variables are set.

# Exit if no arguments are provided

if [ $# -eq 0 ]; then
    echo "Error: No environment variables provided."
    exit 1
fi

# Loop through arguments and check each environment variable
for var in "$@"; do
    if [ -z "${!var}" ]; then
        echo "Error: $var environment variable is not set."
        exit 1
    fi
done

