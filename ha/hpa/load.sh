#!/bin/bash

kubectl run -i --tty load-generator --rm --image=busybox:1.28 --restart=Never -- /bin/sh -c "while sleep 0.00001; do wget -q -O- http://nginx-app; done"
