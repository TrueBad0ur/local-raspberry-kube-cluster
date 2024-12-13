helm show values loft/vcluster > values.yml

helm upgrade --install vcluster vcluster --values values.yml --repo https://charts.loft.sh --namespace vcluster --repository-config='' --create-namespace