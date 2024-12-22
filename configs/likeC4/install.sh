./gen-configmaps.sh

k apply -f .

kubectl create secret generic authsecret \
  --from-literal=username=admin \
  --from-literal=password=admin \
  --type=kubernetes.io/basic-auth \
  -n likec4
