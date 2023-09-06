#/bin/bash
set -e
SERVER=localhost:9999
ARGOCD=argocd
ARGOCD_NAMESPACE=argocd
USERNAME=admin
APP_NAME=homelab
REPO_NAME=https://github.com/heathj/k3s-vagrant.git
# must be a directory in repo
REPO_PATH=infra
NAMESPACE=homelab

# install ArgoCD
kubectl create namespace ${ARGOCD_NAMESPACE}
# todo: switch to the core packages 
kubectl apply -n ${ARGOCD_NAMESPACE} -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
if ! command -v ${ARGOCD} &> /dev/null
then
    curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
    sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
    rm argocd-linux-amd64
fi

# the secret doesn't show up right away
sleep 180
until PASSWORD=$(kubectl get secret argocd-initial-admin-secret -n ${ARGOCD_NAMESPACE}  -o json | jq '  {name: .metadata.name,data: .data|map_values(@base64d)}' | jq -r '.data.password')
do
    echo "waiting for secret..."
    sleep 20
done
kubectl port-forward service/argocd-server -n ${ARGOCD_NAMESPACE} 9999:https &> /dev/null &
${ARGOCD} login ${SERVER} --insecure --username ${USERNAME} --password ${PASSWORD}
kubectl create namespace ${NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -
${ARGOCD} app create ${APP_NAME} --repo ${REPO_NAME} --path ${REPO_PATH} --dest-server https://kubernetes.default.svc --dest-namespace ${NAMESPACE} --server ${SERVER} --insecure
${ARGOCD} app sync ${APP_NAME}