create pvc(pv provisioned), pod
delete pvc, pod
kubectl patch pv PVNAME -p '{"spec":{"claimRef": null}}'
pv status became available
apply pvc, pod
bingo!
