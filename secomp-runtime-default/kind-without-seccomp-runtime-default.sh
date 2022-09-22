#!/bin/sh
mkdir -p /tmp/seccomp
kind create cluster --name seccomp-without-runtime-default --image kindest/node:v1.24.0
kubectl cluster-info --context kind-seccomp-without-runtime-default
# Wait for 15 seconds (arbitrary) ServiceAccount Admission Controller to be available
sleep 15
cat <<EOF > /tmp/seccomp/forever-asleep.yaml
apiVersion: v1
kind: Pod
metadata:
  name: forever-asleep
spec:
  containers:
  - name: forever-asleep
    securityContext:
      capabilities:
        add: ["SYS_TIME"]
    image: ubuntu:latest
    # Sleep forever
    command: [ "/bin/bash", "-c", "--" ]
    args: [ "sleep infinity" ]
EOF
kubectl apply -f /tmp/seccomp/forever-asleep.yaml
sleep 5
kubectl exec --stdin --tty forever-asleep -- /bin/bash

