#!/bin/bash

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

