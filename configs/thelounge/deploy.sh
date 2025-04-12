#!/bin/zsh

source ~/.zshrc

k apply -f ns.yml

k create secret generic user-config -n irc --from-file=truebad0ur.json

k apply -f configmap.yml

k apply -f deploy.yml

k apply -f ingress.yml

-----------------

k create secret generic user-config -n irc --from-file=truebad0ur.json

deploy with argo-cd
