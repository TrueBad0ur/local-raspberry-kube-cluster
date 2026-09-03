Previously compile kernel all all needed kernel structures:
https://github.com/aquasecurity/tracee/issues/4649
Needs CONFIG_UPROBE_EVENTS enabled on the kernel (custom Pi builds via bcm2712_defconfig don't
set it by default) or Tracee's CO-RE relocation for struct trace_uprobe fails at startup.

helm repo add aqua-tracee https://aquasecurity.github.io/helm-charts/
helm upgrade --install my-tracee aqua-tracee/tracee --version 0.23.0 -n tracee -f values.yml
kubectl apply -f policy.yml -f service.yml -f servicemonitor.yml
