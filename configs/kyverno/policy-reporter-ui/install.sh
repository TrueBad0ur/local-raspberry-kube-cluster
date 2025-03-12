helm repo add policy-reporter https://kyverno.github.io/policy-reporter
helm upgrade --install policy-reporter policy-reporter/policy-reporter -n kyverno -f values.yml

htpasswd -c auth admin
kubectl create secret generic basic-auth --from-file=auth -n kyverno
