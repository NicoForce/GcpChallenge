if [ $# -lt 1 ]
then
    echo "Usage : ./main.sh JSON_KEY_PATH"
    exit
fi

JSON_KEY="${1}"
PROJECT_ID=$(jq -r '.project_id' "${JSON_KEY}")

NAME="task1-cluster"
REGION="us-central1"
cd terraform || exit 1
terraform plan
terraform destroy -auto-approve \
  -var "project-id=${PROJECT_ID}" \
  -var "credentials=../${JSON_KEY}" \
  -var "name=${NAME}" \
  -var "location=${REGION}"
cd ..