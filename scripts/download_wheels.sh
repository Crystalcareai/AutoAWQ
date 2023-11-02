#!/bin/bash

# Set variables
AWQ_VERSION="0.1.6"
CUDA_VERSION="cu1180"
RELEASE_URL="https://api.github.com/repos/casper-hansen/AutoAWQ/releases/tags/v${AWQ_VERSION}"

# Create a directory to download the wheels
mkdir -p dist
cd dist

# Download all the wheel files from the GitHub release
curl -s $RELEASE_URL | \
    jq -r ".assets[].browser_download_url" | \
    grep '\.whl' | \
    grep "$CUDA_VERSION" | \
    xargs -n 1 wget

# Rename the wheels from 'linux_x86_64' to 'manylinux_x86_64'
# Remove CUDA version from filename
for file in *"$CUDA_VERSION"*.whl; do
    # First, rename the platform from 'linux_x86_64' to 'manylinux2014_x86_64'
    intermediate_name=$(echo "$file" | sed 's/linux_x86_64/manylinux2014_x86_64/')
    
    # Then, remove the CUDA version from the filename
    newname=$(echo "$intermediate_name" | sed "s/+${CUDA_VERSION}//")
    
    mv -v "$file" "$newname"
done


cd ..
