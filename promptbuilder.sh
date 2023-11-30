#!/bin/bash

# promptbuilder.sh dynamically generates prompts for language models from given inputs.
# It reads the project's ABSTRACT.md and uses the output from toolindexer.sh as inputs.
# The script combines these inputs and outputs the resulting prompt as a string to stdout.

# Read the content of ABSTRACT.md
abstract_content=$(cat ABSTRACT.md)

# Run toolindexer.sh and capture its output
tools_output=$(bash ./toolindexer.sh)

# Construct the prompt
prompt="Based on the current project abstract: $abstract_content --- And the available tools as listed and described briefly: $tools_output --- Consider the specific user issue and craft a response that outlines a clear, actionable solution to the user's problem. Your response should directly apply the tools available in the context of the project's objectives. Structure your solution in a logical, step-by-step manner to ensure it is practical and easy to follow. If you need additional context clearly state which tool you need to use and how you would call it in the command line."

# Output the constructed prompt
echo -e "$prompt"

