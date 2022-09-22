# Tutorial: Reducing the Sticker Price of Kubernetes Security

Scripts, Slides and Other Details for KubeCon NA 2022 tutorial: https://sched.co/182K6

## Pre-requisites

> Please **DO NOT** run the scripts in this tutorial in a production environment. 
> Use a local environment that is not shared with other users
> If you are uncomfortable or unable to run any of the scripts, it's okay! 
> Follow along with the rest of the class and try it later in your own free time!

### Docker

Docker Desktop is preferred but not needed. 

https://docs.docker.com/engine/install/

### KinD

KinD (Kubernetes in Docker) is a local Kubernetes Installer that uses Docker 

https://kind.sigs.k8s.io/docs/user/quick-start/#installing-with-a-package-manager

Using minikube is okay, but you may need to modify some of the steps like creating a cluster as they are different from when using kind.

### kubectl

https://kubernetes.io/docs/tasks/tools/#kubectl

### Cosign

1. Install Go: https://go.dev/dl/
2. Install Cosign: go install github.com/sigstore/cosign/cmd/cosign@latest

Ref: https://docs.sigstore.dev/cosign/installation/

### curl

https://command-not-found.com/curl


