Previously compile kernel all all needed kernel structures:
https://github.com/aquasecurity/tracee/issues/4649

helm upgrade --install my-tracee trivy-operator/tracee --version 0.23.0 -n tracee -f values.yml
