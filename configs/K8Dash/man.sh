kubectl create serviceaccount k8dash-sa
kubectl create clusterrolebinding k8dash-sa --clusterrole=cluster-admin --serviceaccount=default:k8dash-sa

kubectl create token k8dash-sa
