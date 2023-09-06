#/bin/bash
set -e

kubectl port-forward service/argocd-server -n argocd 9999:https &> /dev/null &

SERVER=localhost:9999
ARGOCD=argocd
USERNAME=admin
PASSWORD=$(kubectl get secret argocd-initial-admin-secret -n argocd  -o json | jq '  {name: .metadata.name,data: .data|map_values(@base64d)}' | jq -r '.data.password')
APP_NAME=homelab
REPO_NAME=https://github.com/heathj/k3s-vagrant.git
# must be a directory in repo
REPO_PATH=infra
NAMESPACE=homelab

# install ArgoCD
if ! command -v ${ARGOCD} &> /dev/null
then
    curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
    sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
    rm argocd-linux-amd64
fi

${ARGOCD} login ${SERVER} --insecure --username ${USERNAME} --password ${PASSWORD}
kubectl create namespace ${NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -
${ARGOCD} app create ${APP_NAME} --repo ${REPO_NAME} --path ${REPO_PATH} --dest-server https://kubernetes.default.svc --dest-namespace ${NAMESPACE} --server ${SERVER} --insecure
argocd app sync ${APP_NAME}