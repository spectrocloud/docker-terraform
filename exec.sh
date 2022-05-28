INPUT=$1

function exec_cmd() {
  echo "executing command $1"
  if ${1}
  then
    echo "executed command successfully $1"
  else
    echo "failed to run command $1"
    exit 1
  fi
}

[ ! -z "$PREEXECCMD" ] && echo "pre exec command: $POSTEXECCMD"; exec_cmd "${PREEXECCMD}"

if terraform init --plugin-dir /providers/plugins > /dev/null 2>&1; then
  terraform init --plugin-dir /providers/plugins # first check if provider is cached locally and if it is not present then download
else
  rm -rf .terraform* /root/.terraform* # folder & lock file from last init command must be removed
  exec_cmd "terraform init"
fi

if [[ ${INPUT} == 'apply' ]]; then
  exec_cmd "terraform apply -lock=false -auto-approve"
else
    exec_cmd "terraform destroy -lock=false -auto-approve"
fi

[ ! -z "$POSTEXECCMD" ] && echo "post exec command: $POSTEXECCMD"; exec_cmd "${POSTEXECCMD}"

exit 0