helm repo add longhorn https://charts.longhorn.io
helm install longhorn longhorn/longhorn --namespace longhorn-system -f values.yml

mb you should patch and enable allowVolumeExpansion
