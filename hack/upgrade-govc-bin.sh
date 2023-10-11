#!/bin/bash
# This script checks the current version of govc binary and updates it to the latest version if needed

# Get the current version of govc binary
CURRENT_VERSION="v$(bin/govc version | grep govc | cut -d ' ' -f 2)"

# Get the latest version of govc binary from GitHub releases
LATEST_VERSION=$(curl -s https://api.github.com/repos/vmware/govmomi/releases/latest | grep tag_name | cut -d '"' -f 4)

# Compare the current and latest versions
if [ "$CURRENT_VERSION" == "$LATEST_VERSION" ]; then
  echo "You have the latest version of govc: $CURRENT_VERSION"
else
  echo "You have an outdated version of govc: $CURRENT_VERSION"
  echo "Updating to the latest version: $LATEST_VERSION"

  cd bin
  rm govc
  # Download the latest govc binary for Linux
  wget https://github.com/vmware/govmomi/releases/latest/download/govc_$(uname -s)_$(uname -m).tar.gz
  tar -xvzf govc_$(uname -s)_$(uname -m).tar.gz
  rm CHANGELOG.md
  rm LICENSE.txt
  rm README.md
  rm govc_$(uname -s)_$(uname -m).tar.gz
  cd -

  # Verify the updated version
  UPDATED_VERSION=$(bin/govc version | grep govc | cut -d ' ' -f 2)
  echo "Updated version of govc: $UPDATED_VERSION"
fi
