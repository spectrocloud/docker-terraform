INPUT=$1

if [[ ${INPUT} == 'apply' ]]; then
  if terraform apply -lock=false -auto-approve ; then
    echo "Applied successfully.."
  else
    echo "Apply failed.. Thus cleaning it up.."
    terraform destroy -lock=false -auto-approve
  fi
else
  terraform destroy -lock=false -auto-approve
fi