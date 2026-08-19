for ip in $(kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}'); do
  ssh user@$ip "sudo apt install -y open-iscsi nfs-common"
done

helm repo add longhorn https://charts.longhorn.io
helm repo update
helm upgrade -i --create-namespace --namespace longhorn-system --version 1.12.1 longhorn longhorn/longhorn -f values.yml

kubectl apply -f storageclass-rwx.yml
