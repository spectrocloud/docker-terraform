INPUT=$1

if terraform init --plugin-dir /providers/plugins > /dev/null 2>&1; then
  terraform init --plugin-dir /providers/plugins # first check if provider is cached locally and if it is not present then download
else
  rm -rf .terraform* /root/.terraform* # folder & lock file from last init command must be removed
  terraform init
fi

if [[ ${INPUT} == 'apply' ]]; then
  terraform apply -lock=false -auto-approve
else
  terraform destroy -lock=false -auto-approve
fi