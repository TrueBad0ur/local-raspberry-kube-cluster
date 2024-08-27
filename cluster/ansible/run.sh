#!/bin/bash

# first param is [install/clear]

master_ip=$(awk '/^\[masters\]/{getline; print $2}' hosts | cut -d'=' -f2)

ansible-playbook -i hosts $1.yml --skip-tags unreadable && \
ssh user@$master_ip -i ~/.ssh/id_rsa_private "sudo -u root cat /etc/rancher/k3s/k3s.yaml" > config.yaml && \
sed -i '.bak' -e "s|server: https://127.0.0.1:6443|server: https://$master_ip:6443|g" config.yaml && \
rm config.yaml.bak && \
ansible-playbook -i hosts $1.yml --tags unreadable