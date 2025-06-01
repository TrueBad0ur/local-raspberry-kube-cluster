#!/bin/bash

echo "🔍 Finding failed or restarted pods"

BAD_STATUSES=("Error" "CrashLoopBackOff" "ContainerStatusUnknown" "RunContainerError" "ImagePullBackOff")

kubectl get pods -A --no-headers | while read -r line; do
  ns=$(echo $line | awk '{print $1}')
  pod=$(echo $line | awk '{print $2}')
  status=$(echo $line | awk '{print $4}')
  restarts=$(echo $line | awk '{print $5}')

  if [[ -z "$ns" || -z "$pod" ]]; then
    continue
  fi

  is_bad_status=false
  for bad in "${BAD_STATUSES[@]}"; do
    if [[ "$status" == "$bad" ]]; then
      is_bad_status=true
      break
    fi
  done

  if [[ "$is_bad_status" == true || "$restarts" -gt 0 ]]; then
    echo "🧹 Deleting pod: $pod from namespace: $ns (Status: $status, Restarts: $restarts)"
    kubectl delete pod "$pod" -n "$ns"
  fi
done

echo "✅ Done. All failed pods deleted."
