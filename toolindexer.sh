#!/bin/bash

# lists all .sh files in directory and prints lines 3-5 which contain the docstring
# use this to get an overview of which tools are available
# usage: ./toolindexer.sh


for file in ./*.sh; do
    if [ -f "$file" ]; then
        echo "## $file"
        echo
        echo '```bash'
        sed -n '3,5p' "$file"  # This will print lines 3 to 5 of the file
        echo '```'
        echo
    fi
done

