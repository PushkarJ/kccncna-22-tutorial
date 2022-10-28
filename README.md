# Tutorial: Reducing the Sticker Price of Kubernetes Security

Scripts, Slides and Other Details for KubeCon NA 2022 tutorial: https://sched.co/182K6

## Pre-requisites

> Please **DO NOT** run the scripts in this tutorial in a production environment.
> Use a local environment that is not shared with other users

### Git

Clone this repository:

```
git clone https://github.com/PushkarJ/kccncna-22-tutorial.git
```

### Docker

"Docker Desktop" is preferred over static binaries

https://docs.docker.com/engine/install/

### Using homebrew or Linux brew

If you have homebrew installed, you can run `brew bundle` to install pre-requisites.

### KinD

KinD (Kubernetes in Docker) is a local Kubernetes Installer that uses Docker

https://kind.sigs.k8s.io/docs/user/quick-start/#installing-with-a-package-manager

Using minikube is okay, but you may need to modify some of the steps like creating a cluster as they are different from when using kind.

### kubectl

https://kubernetes.io/docs/tasks/tools/#kubectl

### Cosign

1. Install Go: https://go.dev/dl/
2. Install Cosign: `go install github.com/sigstore/cosign/cmd/cosign@latest`

Ref: https://docs.sigstore.dev/cosign/installation/

### curl

https://command-not-found.com/curl
