#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <version>"
    echo "Example: $0 1.0.1"
    exit 1
fi

# Run the Dart script to update versions
dart tools/update_version.dart "$1"

# If successful, commit and push
if [ $? -eq 0 ]; then
    git add lib/src/version.dart pubspec.yaml
    git commit -m "Bump version to $1"
    git push origin main
fi 