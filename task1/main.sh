# Identify action required: CREATE, DESTROY or OUTPUT
if [ $# -lt 2 ]
then
    echo "Usage : ./main.sh [CREATE/DELETE/OUTPUT] JSON_KEY_PATH"
    exit
fi

JSON_KEY="${2}"
PROJECT_ID=$(jq -r '.project_id' "${JSON_KEY}")
KEY_EMAIL=$(jq -r '.client_email' "${JSON_KEY}")

function create() {
  #set on stone variables
  NAME="task1-cluster"
  REGION="us-central1"
  SECRET_NAME="registry"

  # Terraform phase
  cd terraform || exit 1
  terraform plan
  terraform apply -auto-approve \
    -var "project-id=${PROJECT_ID}" \
    -var "credentials=../${JSON_KEY}" \
    -var "name=${NAME}" \
    -var "location=${REGION}"
  cd ..

  # Gcloud auth
  gcloud auth activate-service-account "${KEY_EMAIL}" \
    --key-file="${JSON_KEY}"
  gcloud container clusters get-credentials "${NAME}" --region "${REGION}" --project "${PROJECT_ID}"

  # Cluster setup
  kubectl create serviceaccount --namespace kube-system tiller
  kubectl create clusterrolebinding tiller-cluster-rule \
    --clusterrole=cluster-admin \
    --serviceaccount=kube-system:tiller
  helm init --service-account tiller
  kubectl rollout status deployment tiller-deploy -n kube-system
  kubectl create secret docker-registry ${SECRET_NAME} \
    --docker-server=https://gcr.io \
    --docker-username=_json_key \
    --docker-password="$(cat ${JSON_KEY})"

  # App setup
  cat ${JSON_KEY} | docker login -u _json_key --password-stdin https://gcr.io/
  cd python-app || exit 1
  docker build --rm -t "gcr.io/${PROJECT_ID}/mypythonapp" .
  docker push "gcr.io/${PROJECT_ID}/mypythonapp"
  kubectl apply -f app.yaml

  #Helm chart at the end because it tends to fail
  helm install --name nginx-ingress stable/nginx-ingress \
    --set rbac.create=true \
    --set controller.publishService.enabled=true
}

# Destroy
function delete() {
  cd terraform || exit 1
  terraform destroy -auto-approve \
    -var "project-id=${PROJECT_ID}" \
    -var "credentials=../${JSON_KEY}" \
    -var "name=${NAME}" \
    -var "location=${REGION}"
  cd ..
}

# Output
function output() {
  EXTERNAL_IP=$(kubectl get svc nginx-ingress-controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
  if [[ "$EXTERNAL_IP" == *"The connection to the server"* ]]; then
    echo "Kubernetes cluster is down or ingress is not ready yet."
  else
    echo "Access the python app at http://${EXTERNAL_IP}/greetings or http://${EXTERNAL_IP}/square"
  fi
}

case "$1" in
"CREATE")  echo "Create command identified"
    create
    exit 0;;
"DELETE")  echo  "Delete command identified"
    delete
    exit 0;;
"OUTPUT")  echo  "Output command identified"
    output
    exit 0;;
*) echo "No Sub-command was found"
   exit 1;;
esac