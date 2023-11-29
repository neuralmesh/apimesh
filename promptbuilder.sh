#!/bin/bash

# promptbuilder.sh dynamically generates prompts for language models from given inputs.
# It reads the project's ABSTRACT.md and uses the output from toolindexer.sh as inputs.
# The script combines these inputs and outputs the resulting prompt as a string to stdout.

# Read the content of ABSTRACT.md
abstract_content=$(cat ABSTRACT.md)

# Run toolindexer.sh and capture its output
tools_output=$(bash ./toolindexer.sh)

# Construct the prompt
prompt="Based on the current project abstract: \n$abstract_content\n\n"
prompt+="And the available tools as listed and described briefly: \n$tools_output\n\n"
prompt+="Craft a guide that details how to use these tools effectively in the context of the project's objectives."

# Output the constructed prompt
echo -e "$prompt"

