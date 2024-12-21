#!/bin/bash

read -p "Введите namespace: " NAMESPACE

printf "%-40s %-15s %-15s\n" "Pod Name" "CPU Usage" "Memory Usage"

total_cpu=0
total_mem=0

# bash
# declare -A node_cpu
# declare -A node_mem

# zsh
# typeset -A node_cpu
# typeset -A node_mem

# alternative zsh
node_cpu_data=()
node_mem_data=()

pods_output=$(kubectl top pod -n $NAMESPACE | awk 'NR>1 {print $1, $2, $3}')

while read -r pod cpu mem; do
  node=$(kubectl get pod "$pod" -n $NAMESPACE -o jsonpath='{.spec.nodeName}')

  printf "%-40s %-15s %-15s\n" "$pod" "$cpu" "$mem"

  cpu_value=$(echo "$cpu" | sed 's/m//')
  mem_value=$(echo "$mem" | sed 's/Mi//')

  total_cpu=$((total_cpu + cpu_value))
  total_mem=$((total_mem + mem_value))

  node_cpu[$node]=$(( ${node_cpu[$node]} + cpu_value ))
  node_mem[$node]=$(( ${node_mem[$node]} + mem_value ))
done <<< "$pods_output"

echo
echo "Total CPU Usage: ${total_cpu}m"
echo "Total Memory Usage: ${total_mem}Mi"

echo
echo "Resource usage by node:"
for node in "${!node_cpu[@]}"; do
  echo "Node: $node"
  echo "  CPU Usage: ${node_cpu[$node]}m"
  echo "  Memory Usage: ${node_mem[$node]}Mi"
done
