❯ kubectl get pods -l app=multiarch-demo -o jsonpath='{range.items[*]}{.spec.nodeName}{"\t"}{.status.containerStatuses[0].imageID}{"\n"}{end}'                 
worker3 docker.io/truebad0ur/multiarch-demo@sha256:d08de45f1e71a206ac43ad78697e1ff12f969c071b69401859ae547009b8546d
worker2 docker.io/truebad0ur/multiarch-demo@sha256:d08de45f1e71a206ac43ad78697e1ff12f969c071b69401859ae547009b8546d
worker4 docker.io/truebad0ur/multiarch-demo@sha256:d08de45f1e71a206ac43ad78697e1ff12f969c071b69401859ae547009b8546d
worker5 docker.io/truebad0ur/multiarch-demo@sha256:d08de45f1e71a206ac43ad78697e1ff12f969c071b69401859ae547009b8546d
worker1 docker.io/truebad0ur/multiarch-demo@sha256:d08de45f1e71a206ac43ad78697e1ff12f969c071b69401859ae547009b8546d
master  docker.io/truebad0ur/multiarch-demo@sha256:d08de45f1e71a206ac43ad78697e1ff12f969c071b69401859ae547009b8546d
worker6 docker.io/truebad0ur/multiarch-demo@sha256:d08de45f1e71a206ac43ad78697e1ff12f969c071b69401859ae547009b8546d

❯ kubectl get pods -l app=multiarch-demo -o name | xargs -I{} sh -c 'echo -n "{}: " && kubectl exec {} -- uname -m'
pod/multiarch-demo-4jhww: aarch64
pod/multiarch-demo-8lq7x: x86_64
pod/multiarch-demo-cxtfv: aarch64
pod/multiarch-demo-r8gqv: aarch64
pod/multiarch-demo-snw85: x86_64
pod/multiarch-demo-x4tfs: x86_64
pod/multiarch-demo-zptzc: aarch64



Apply metal lb from configs/metallb
10.10.10.X multiarch.lan