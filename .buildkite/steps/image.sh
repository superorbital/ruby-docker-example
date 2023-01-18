#!/bin/bash

set -euxo pipefail

apk add jq

mkdir ~/.docker
cp /creds/.docker/config.json ~/.docker/config.json

docker buildx create --name remote --driver remote --driver-opt cacert=/buildkit/certs/ca.pem,cert=/buildkit/certs/cert.pem,key=/buildkit/certs/key.pem tcp://buildkitd.default.svc:1234

docker buildx use remote
docker buildx build --tag="ghcr.io/superorbital/ruby-docker-example:${BUILDKITE_COMMIT}" --platform=linux/arm64 --push --metadata-file="$(pwd)/metadata.json" --build-arg REPO="${BUILDKITE_REPO}" .

image=$(jq -r '"\(."image.name")@\(."containerimage.digest")"' metadata.json)
buildkite-agent meta-data set "image" "${image}"