SECRET_NAME=registry

kubectl create secret docker-registry $SECRET_NAME \
  --docker-server=https://gcr.io \
  --docker-username=_json_key \
  --docker-password="$(cat admin-myproject.json)"
  #  --docker-email=user@example.com \