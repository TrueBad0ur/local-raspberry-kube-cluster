#!/bin/bash

NODE_NAME="NODENAME"
PERCENT=20

echo "Getting the list of pods on the node $NODE_NAME..."
PODS_JSON=$(kubectl get pods -A -o json --field-selector spec.nodeName=$NODE_NAME)

echo "Filtering controllable pods (from Deployment)..."
CONTROLLED_PODS=()

for row in $(echo "$PODS_JSON" | jq -r '.items[] | @base64'); do
  _jq() {
    echo "${row}" | base64 --decode | jq -r "${1}"
  }

  ns=$(_jq '.metadata.namespace')
  name=$(_jq '.metadata.name')
  owner_kind=$(_jq '.metadata.ownerReferences[0].kind // empty')

  if [[ "$owner_kind" == "ReplicaSet" && -n "$ns" && -n "$name" ]]; then
    CONTROLLED_PODS+=("${ns}:::${name}")
  fi
done

TOTAL=${#CONTROLLED_PODS[@]}
DELETE_COUNT=$((TOTAL * PERCENT / 100))

echo "Total controllable pods: $TOTAL. Will be deleted $DELETE_COUNT from them"

SHUFFLED=($(printf "%s\n" "${CONTROLLED_PODS[@]}" | shuf))

for ((i = 0; i < DELETE_COUNT; i++)); do
  entry="${SHUFFLED[$i]}"
  ns="${entry%%:::*}"
  pod="${entry##*:::}"

  if [[ -n "$pod" && -n "$ns" ]]; then
    echo "🧹 Deleting pod: $pod from namespace: $ns"
    kubectl delete pod "$pod" -n "$ns"
  else
    echo "⚠️ ПSkipped empty pod or namespace"
  fi
done

echo "✅ Done. Scheduler should reshedule workloads."
