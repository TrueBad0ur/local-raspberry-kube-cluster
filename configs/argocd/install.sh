helm install argo-cd argo/argo-cd -n argo-cd -f values.yml

k delete crd applications.argoproj.io applicationsets.argoproj.io appprojects.argoproj.io
