#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <version>"
    echo "Example: $0 1.0.1"
    exit 1
fi

# Run the Dart script to update versions
dart tools/update_version.dart "$1"

# If successful, update Android version and commit
if [ $? -eq 0 ]; then
    # Get the version code from pubspec.yaml (number after +)
    VERSION_CODE=$(grep "version:" pubspec.yaml | sed 's/.*+//')
    
    # Update Android version in build.gradle using sed
    sed -i'' -e "s/versionCode .*/versionCode $VERSION_CODE/" \
             -e "s/versionName .*/versionName \"$1\"/" \
             android/app/build.gradle
    
    # Commit and push all version-related changes
    git add lib/src/version.dart pubspec.yaml android/app/build.gradle
    git commit -m "Bump version to $1"
    git push origin main
fi 