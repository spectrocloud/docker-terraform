set -x
# accept two arguments from command line
# 1. the name of the Terraform provider
# 2. the version of the Terraform provider

PROVIDER_NAME=$1
PROVIDER_VERSION=$2
USER=$3

echo "Downloading: $PROVIDER_NAME, $PROVIDER_VERSION, $USER"

TERRAFORM_DIR=.terraform.d/plugins/registry.terraform.io

# ./.terraform/providers/registry.terraform.io/dmacvicar/libvirt/0.6.12/linux_amd64/terraform-provider-libvirt_v0.6.12

# wget https://github.com/dmacvicar/terraform-provider-libvirt/releases/download/v0.6.14/terraform-provider-libvirt_0.6.14_linux_amd64.zip
GITHUB_DOMAIN=https://github.com
PROVIDER_RUL=$GITHUB_DOMAIN/"$USER"/terraform-provider-"$PROVIDER_NAME"/releases/download/"v$PROVIDER_VERSION"/terraform-provider-"$PROVIDER_NAME"_"$PROVIDER_VERSION"_linux_amd64.zip
echo "Provider Url: $PROVIDER_RUL"
wget "$PROVIDER_RUL" -O provider.zip &&
  unzip provider.zip &&
  chmod +x terraform-provider-"$PROVIDER_NAME"_* &&
  mkdir -p $TERRAFORM_DIR/$USER/"$PROVIDER_NAME"/"$PROVIDER_VERSION"/linux_amd64 &&
  mv terraform-provider-"$PROVIDER_NAME"_* $TERRAFORM_DIR/$USER/"$PROVIDER_NAME"/"$PROVIDER_VERSION"/linux_amd64
  #rm -f provider-.zip
