helm upgrade --install --namespace nexus --values ./values.yml nexus stevehipwell/nexus3

in nexus: apt proxy
Distribution: bookworm
Remote storage: http://deb.debian.org/debian
sources.list: deb http://nexus-nexus3.nexus.svc:8081/repository/apt-packages/ bookworm main