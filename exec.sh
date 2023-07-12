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

function persistLog(){
  mkdir -p /opt/spectrocloud/logs/tf-pods
  pod_name=$(/bin/hostname)
  file_name=/opt/spectrocloud/logs/tf-pods/$pod_name.log
  kubectl logs $pod_name -n $NAMESPACE > $file_name;
  kubectl logs -l app=terraform-controller -n $NAMESPACE --since=30s >> $file_name
  rm -rf `ls -t /opt/spectrocloud/logs/tf-pods/ | awk 'NR>200'`
}

if [[ $PERSIST_POD_LOGS_SIGINT == "true" ]]; then
  trap "persistLog; exit 0" SIGINT
fi

if [[ $PERSIST_POD_LOGS_SIGTERM == "true" ]]; then
  trap "persistLog; exit 0" SIGTERM
fi

if [[ $PERSIST_POD_LOGS == "true" ]]; then
  trap "persistLog; exit 0" EXIT
fi

[ ! -z "$PREEXECCMD" ] && echo "pre exec command: $PREEXECCMD"; exec_cmd "${PREEXECCMD}"

# Specific to GE
if [[ $TF_VAR_LAYER_NAME ]] && [[ $TF_VAR_DEPLOYMENT_MODE ]]; then 
    if [[ $TF_VAR_LAYER_NAME == "active" ]] && [[ $TF_VAR_DEPLOYMENT_MODE == "standalone" ]]; then
        echo "do not deploy active in standalone mode"
        exit 0
    fi
    if [[ $TF_VAR_LAYER_NAME == "standby" ]] && [[ $TF_VAR_DEPLOYMENT_MODE == "standalone" ]]; then
        echo "do not deploy standby in standalone mode"
        exit 0
    fi
    if [[ $TF_VAR_LAYER_NAME == "standalone" ]] && [[ $TF_VAR_DEPLOYMENT_MODE == "ha" ]]; then
        echo "do not deploy standalone in ha mode"
        exit 0
    fi
fi

if terraform init --plugin-dir /providers/plugins > /dev/null 2>&1; then
  terraform init --plugin-dir /providers/plugins # first check if provider is cached locally and if it is not present then download
else
  rm -rf .terraform* /root/.terraform* # folder & lock file from last init command must be removed
  exec_cmd "terraform init"
fi

TAINT=$(kubectl get cm $TF_VAR_VM_NAME-taint)
if [[ ${INPUT} == 'apply' ]]; then
  if [ -n "$TAINT" ]; then
    exec_cmd "terraform destroy -lock=false -auto-approve"
    kubectl delete cm $TF_VAR_VM_NAME-taint
    exec_cmd "terraform apply -lock=false -auto-approve"
  else
    exec_cmd "terraform apply -lock=false -auto-approve"
  fi
else
  exec_cmd "terraform destroy -lock=false -auto-approve"
fi

[ ! -z "$POSTEXECCMD" ] && echo "post exec command: $POSTEXECCMD"; exec_cmd "${POSTEXECCMD}"

exit 0