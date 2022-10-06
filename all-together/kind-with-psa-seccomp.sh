#!/bin/sh

set -o errexit
set -o nounset
set -o pipefail

mkdir -p /tmp/all

cat <<EOF > /tmp/all/cluster-level-all.yaml
apiVersion: apiserver.config.k8s.io/v1
kind: AdmissionConfiguration
plugins:
- name: PodSecurity
  configuration:
    apiVersion: pod-security.admission.config.k8s.io/v1
    kind: PodSecurityConfiguration
    defaults:
      enforce: "baseline"
      enforce-version: "latest"
      audit: "restricted"
      audit-version: "latest"
      warn: "restricted"
      warn-version: "latest"
    exemptions:
      usernames: []
      runtimeClasses: []
      namespaces: [kube-system]
EOF

cat <<EOF > /tmp/all/cluster-config.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  image: kindest/node:v1.25.0@sha256:6e0f9005eba4010e364aa1bb25c8d7c64f050f744258eb68c4eb40c284c3c0dd
  kubeadmConfigPatches:
  - |
    kind: JoinConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        seccomp-default: "true"
  - |
    kind: ClusterConfiguration
    apiServer:
        extraArgs:
          admission-control-config-file: /etc/config/cluster-level-all.yaml
        extraVolumes:
          - name: accf
            hostPath: /etc/config
            mountPath: /etc/config
            readOnly: false
            pathType: "DirectoryOrCreate"
  extraMounts:
  - hostPath: /tmp/all
    containerPath: /etc/config
    # optional: if set, the mount is read-only.
    # default false
    readOnly: false
    # optional: if set, the mount needs SELinux relabeling.
    # default false
    selinuxRelabel: false
    # optional: set propagation mode (None, HostToContainer or Bidirectional)
    # see https://kubernetes.io/docs/concepts/storage/volumes/#mount-propagation
    # default None
    propagation: None            
- role: worker
  image: kindest/node:v1.25.0@sha256:6e0f9005eba4010e364aa1bb25c8d7c64f050f744258eb68c4eb40c284c3c0dd
  kubeadmConfigPatches:
  - |
    kind: JoinConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        seccomp-default: "true"                
EOF


kind create cluster --name all --image kindest/node:v1.25.2 --config /tmp/all/cluster-config.yaml
kubectl cluster-info --context kind-all
# Wait for 15 seconds (arbitrary) to allow ServiceAccount Admission Controller to be available
sleep 15
cat <<EOF > /tmp/all/nginx-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
    - image: nginx
      name: nginx
      ports:
        - containerPort: 80
EOF
kubectl apply -f /tmp/all/nginx-pod.yaml

# Wait for 15 seconds (arbitrary) ServiceAccount Admission Controller to be available
sleep 15

cat <<EOF > /tmp/all/forever-asleep.yaml
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

kubectl apply -f /tmp/all/forever-asleep.yaml
sleep 30
kubectl exec --stdin --tty forever-asleep -- /bin/bash


