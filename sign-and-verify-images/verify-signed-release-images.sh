#!/bin/sh

set -o errexit
set -o nounset
set -o pipefail

echo "Image List is empty"
curl -Ls https://sbom.k8s.io/$(curl -Ls https://dl.k8s.io/release/latest.txt)/release | grep 'PackageName: registry.k8s.io/' | awk '{print $2}' > images.txt
input=images.txt

echo "Image List is empty"

while IFS= read -r image
do
  COSIGN_EXPERIMENTAL=1 cosign verify "$image"
done < "$input"

