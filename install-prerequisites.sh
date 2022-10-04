#!/bin/sh

set -o errexit
set -o nounset
set -o pipefail

echo "Installing kind..."

echo "Installing kubectl..."

echo "Installing cosign..."

go install github.com/sigstore/cosign/cmd/cosign@latest

if [ $1 == "windows" ]; then

    echo "Installing kubectl..."

    curl.exe -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/windows/amd64/kubectl"

    echo "Installing kind..."

    curl.exe -Lo kind-windows-amd64.exe https://kind.sigs.k8s.io/dl/v0.16.0/kind-windows-amd64
    Move-Item .\kind-windows-amd64.exe c:\some-dir-in-your-PATH\kind.exe
fi

if [ $1 == "darwin" ]; then

    echo "Installing kubectl..."
 
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"

    echo "Installing kind..."
 
    # for Intel Macs
	[ $(uname -m) = x86_64 ]&& curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.16.0/kind-darwin-amd64
	chmod +x ./kind
	mv ./kind /usr/local/bin/kind
fi

if [ $1 == "linux" ]; then

   echo "Installing kubectl..."

   curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

   echo "Installing kind..."

   curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.16.0/kind-linux-amd64
   chmod +x ./kind
   sudo mv ./kind /usr/local/bin/kind
fi


