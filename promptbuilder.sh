#!/bin/bash

# promptbuilder.sh dynamically generates prompts for language models from given inputs.
# It reads the project's ABSTRACT.md and uses the output from toolindexer.sh as inputs.
# The script combines these inputs and outputs the resulting prompt as a string to stdout.

# Read the content of ABSTRACT.md
abstract_content=$(cat ABSTRACT.md)

# Run toolindexer.sh and capture its output
tools_output=$(bash ./toolindexer.sh)

issue_content=$(bash ./issuefetcher.sh)

# Construct the prompt
prompt="Based on the current project abstract: \n$abstract_content\n\nAnd the available tools as listed and described briefly: \n$tools_output\n\nConsider the specific user issue (title, body, comments): \n$user_issue_content\n\nCraft a response that outlines a clear, actionable solution to the user's problem. Your response should directly apply the tools available in the context of the project's objectives. Structure your solution in a logical, step-by-step manner to ensure it is practical and easy to follow."

# Output the constructed prompt
echo -e "$prompt"

