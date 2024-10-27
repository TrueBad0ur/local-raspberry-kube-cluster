helm repo add cilium https://helm.cilium.io
helm install tetragon cilium/tetragon -n kube-system

Find same node where tetragon pod runs:
k get pods --all-namespaces -o wide --field-selector spec.nodeName=host4

Get events for specific pod:
k -n kube-system exec -it pods/tetragon-rmjfs -c tetragon -- tetra getevents -o compact --pods ubuntu

Wait 100500 time and:
💥 exit    tetragon-test/ubuntu /usr/bin/sleep 30 0
🚀 process tetragon-test/ubuntu /usr/bin/curl -s ifconfig.me
💥 exit    tetragon-test/ubuntu /usr/bin/curl -s ifconfig.me 0
🚀 process tetragon-test/ubuntu /usr/bin/sleep 30



To get metrics to prometheus and grafana we need to install crds from prometheus operator

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install my-prometheus-operator-crds prometheus-community/prometheus-operator-crds --version 15.0.0

helm install tetragon cilium/tetragon -n kube-system -f values.yml

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
  -f values.yml
