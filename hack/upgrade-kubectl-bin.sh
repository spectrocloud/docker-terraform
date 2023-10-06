#!/bin/bash
# Get the current kubectl version
CURRENT_VERSION=$(bin/kubectl version --client |head -n 1 | awk '{ print $3 }' | cut -d 'v' -f 2)
# Get the latest stable kubectl version
LATEST_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt | cut -d 'v' -f 2)
# Compare the versions and update if needed
if [ "$CURRENT_VERSION" != "$LATEST_VERSION" ]; then
  echo "Your kubectl version is $CURRENT_VERSION, which is not the latest."
  echo "Updating kubectl to version $LATEST_VERSION..."
  # Download the latest kubectl binary
  cd bin
  rm kubectl
  curl -LO "https://storage.googleapis.com/kubernetes-release/release/v$LATEST_VERSION/bin/linux/amd64/kubectl"
  # Make it executable
  chmod +x ./kubectl
  cd -
  echo "Done. Your kubectl version is now $LATEST_VERSION."
else
  echo "Your kubectl version is $CURRENT_VERSION, which is the latest. No need to update."
fi
