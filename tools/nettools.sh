NS=kube-system
POD_NAME=nettools
kubectl run -it --image=jrecord/nettools ${POD_NAME} --restart=Never --namespace=${NS}
kubectl delete pod ${POD_NAME} -n ${NS}