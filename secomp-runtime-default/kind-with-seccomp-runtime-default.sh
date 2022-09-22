cat <<EOF > /tmp/seccomp/cluster-config.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
featureGates:
  SeccompDefault: true
nodes:
  - role: control-plane
    image: kindest/node:v1.23.0@sha256:49824ab1727c04e56a21a5d8372a402fcd32ea51ac96a2706a12af38934f81ac
    kubeadmConfigPatches:
      - |
        kind: JoinConfiguration
        nodeRegistration:
          kubeletExtraArgs:
            seccomp-default: "true"
  - role: worker
    image: kindest/node:v1.23.0@sha256:49824ab1727c04e56a21a5d8372a402fcd32ea51ac96a2706a12af38934f81ac
    kubeadmConfigPatches:
      - |
        kind: JoinConfiguration
        nodeRegistration:
          kubeletExtraArgs:
            feature-gates: SeccompDefault=true
            seccomp-default: "true"
EOF
kind create cluster --name seccomp-with-runtime-default --image kindest/node:v1.25.0 --config /tmp/seccomp/cluster-config.yaml
kubectl cluster-info --context kind-seccomp-with-runtime-default
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
    image: ubuntu:latest
    # Just spin & wait forever
    command: [ "/bin/bash", "-c", "--" ]
    args: [ "sleep infinity" ]
EOF
kubectl apply -f /tmp/seccomp/forever-asleep.yaml
sleep 5
kubectl exec --stdin --tty forever-asleep -- /bin/bash

