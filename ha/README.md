# HA setup with different ips

### First master node
```bash
curl -sfL https://get.k3s.io | K3S_TOKEN=<token> sh -s - server --cluster-init --tls-san=<globalip>
```

### Other master nodes
```bash
curl -sfL https://get.k3s.io | K3S_TOKEN=<token> sh -s - server --server https://10.10.10.252:6443
```

### Worker nodes
```bash
curl -sfL https://get.k3s.io | K3S_URL=https://10.10.10.252:6443 K3S_TOKEN=<token> sh -
```

# Kube-vip and VIP way

### delete old installation files
```bash
rm -rf /var/lib/rancher /etc/rancher ~/.kube/*; \
ip addr flush dev lo; \
ip addr add 127.0.0.1/8 dev lo;
```

### create manifests
```bash
mkdir -p /var/lib/rancher/k3s/server/manifests/ && curl https://kube-vip.io/manifests/rbac.yaml > /var/lib/rancher/k3s/server/manifests/kube-vip-rbac.yaml
```

### example of this manifest is in the bottom
```bash
export VIP=10.10.10.10
export INTERFACE=eth0
KVVERSION=$(curl -sL https://api.github.com/repos/kube-vip/kube-vip/releases | jq -r ".[0].name")
export KVVERSION="v0.8.2"
alias kube-vip="docker run --network host --rm ghcr.io/kube-vip/kube-vip:$KVVERSION"
kube-vip manifest daemonset --interface $INTERFACE --address $VIP --inCluster --taint --controlplane --services --arp --leaderElection

### add first master
curl -sfL https://get.k3s.io | K3S_TOKEN=<token> sh -s - server --cluster-init --disable servicelb --tls-san=10.10.10.10 --tls-san=SECONDARYIP

### add other masters
curl -sfL https://get.k3s.io | K3S_TOKEN=<token> sh -s - server --server https://10.10.10.252:6443 --disable servicelb --tls-san=10.10.10.10 --tls-san=SECONDARYIP

### add workers

curl -sfL https://get.k3s.io | K3S_URL=https://10.10.10.10:6443 K3S_TOKEN=<token> sh -
```

### daemonset example
```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  creationTimestamp: null
  labels:
    app.kubernetes.io/name: kube-vip-ds
    app.kubernetes.io/version: v0.8.2
  name: kube-vip-ds
  namespace: kube-system
spec:
  selector:
    matchLabels:
  app.kubernetes.io/name: kube-vip-ds
  template:
    metadata:
  creationTimestamp: null
  labels:
    app.kubernetes.io/name: kube-vip-ds
    app.kubernetes.io/version: v0.8.2
    spec:
  affinity:
    nodeAffinity:
  requiredDuringSchedulingIgnoredDuringExecution:
    nodeSelectorTerms:
    - matchExpressions:
      - key: node-role.kubernetes.io/master
    operator: Exists
    - matchExpressions:
      - key: node-role.kubernetes.io/control-plane
    operator: Exists
  containers:
  - args:
    - manager
    env:
    - name: vip_arp
  value: "true"
    - name: port
  value: "6443"
    - name: vip_nodename
  valueFrom:
    fieldRef:
      fieldPath: spec.nodeName
    - name: vip_interface
  value: eth0
    - name: vip_cidr
  value: "32"
    - name: dns_mode
  value: first
    - name: cp_enable
  value: "true"
    - name: cp_namespace
  value: kube-system
    - name: svc_enable
  value: "true"
    - name: svc_leasename
  value: plndr-svcs-lock
    - name: vip_leaderelection
  value: "true"
    - name: vip_leasename
  value: plndr-cp-lock
    - name: vip_leaseduration
  value: "5"
    - name: vip_renewdeadline
  value: "3"
    - name: vip_retryperiod
  value: "1"
    - name: address
  value: 10.10.10.10
    - name: prometheus_server
  value: :2112
    image: ghcr.io/kube-vip/kube-vip:v0.8.2
    imagePullPolicy: IfNotPresent
    name: kube-vip
    resources: {}
    securityContext:
  capabilities:
    add:
    - NET_ADMIN
    - NET_RAW
  hostNetwork: true
  serviceAccountName: kube-vip
  tolerations:
  - effect: NoSchedule
    operator: Exists
  - effect: NoExecute
    operator: Exists
  updateStrategy: {}
```