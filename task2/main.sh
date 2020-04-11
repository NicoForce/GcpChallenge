if [ $# -lt 1 ]
then
    echo "Usage : ./main.sh JSON_KEY_PATH"
    exit
fi

export ANSIBLE_HOST_KEY_CHECKING=False
JSON_KEY="${1}"
PROJECT_ID=$(jq -r '.project_id' "${JSON_KEY}")
NAME="task2"
REGION="us-central1"

#terraform setup
cd terraform || exit 1
terraform plan
terraform apply -auto-approve \
  -var "project-id=${PROJECT_ID}" \
  -var "credentials=../${JSON_KEY}" \
  -var "name=${NAME}" \
  -var "location=${REGION}"
HOST_IP=$(terraform output nat_ip)
cd ..

ansible playbook
echo $HOST_IP
rm ansible/myhosts
echo "task2-instance ansible_host=${HOST_IP} ansible_ssh_user=admin ansible_ssh_extra_args='-o StrictHostKeyChecking=no'" \
  > ansible/myhosts
ansible-playbook ansible/instance-playbook.yml -i ansible/myhosts --private-key=id_rsa

