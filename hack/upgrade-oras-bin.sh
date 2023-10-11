#!/bin/bash

# Get the current oras version
current_version=$(bin/oras version | head -n 1 | awk '{print $2}')

# Get the latest oras version from GitHub releases
latest_version=$(curl -s https://api.github.com/repos/oras-project/oras/releases/latest | grep tag_name | cut -d '"' -f 4)
v=$(echo $latest_version | sed 's/v//g')

# Compare the versions and upgrade if needed
if [ "$current_version" != "$v" ]; then
  echo "Your oras version is outdated. Upgrading to $latest_version..."
  # Install the latest oras binary from GitHub releases
  cd bin/
  wget https://github.com/oras-project/oras/releases/download/$latest_version/oras_${v}_linux_amd64.tar.gz
  tar -xvf oras_${v}_linux_amd64.tar.gz
  rm LICENSE
  rm oras_${v}_linux_amd64.tar.gz
  echo "Done. Your oras version is now $latest_version."
else
  echo "Your oras version is up to date."
fi
