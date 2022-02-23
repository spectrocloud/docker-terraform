set -x
# accept two arguments from command line
# 1. the name of the Terraform provider
# 2. the version of the Terraform provider


PROVIDER_NAME=$1
PROVIDER_VERSION=$2
USER=$3

echo "Copied: $PROVIDER_NAME, $PROVIDER_VERSION, $USER"
echo $(ls -lart /tmp)

TERRAFORM_DIR=.terraform.d/plugins/registry.terraform.io
PROVIDER_URL="https://rishi-public-bucket.s3.us-west-2.amazonaws.com/terraform-provider-""$PROVIDER_NAME"_"v$PROVIDER_VERSION"
echo "Provider Url: $PROVIDER_URL"
wget "$PROVIDER_URL" -O terraform-provider-"$PROVIDER_NAME"_"v$PROVIDER_VERSION"
chmod +x terraform-provider-"$PROVIDER_NAME"_*
mkdir -p $TERRAFORM_DIR/$USER/"$PROVIDER_NAME"/"$PROVIDER_VERSION"/linux_amd64
mv terraform-provider-"$PROVIDER_NAME"_"v$PROVIDER_VERSION" $TERRAFORM_DIR/$USER/"$PROVIDER_NAME"/"$PROVIDER_VERSION"/linux_amd64