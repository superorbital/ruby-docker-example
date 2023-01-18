#!/bin/bash

set -euxo pipefail

apk add jq

docker buildx create --name remote --driver remote --driver-opt cacert=/buildkit/certs/ca.pem,cert=/buildkit/certs/cert.pem,key=/buildkit/certs/key.pem tcp://buildkitd.default.svc:1234

docker buildx use remote
docker buildx build --tag=ttl.sh/buildkite-ruby-sample:5m --platform=linux/arm64 --push --metadata-file="$(pwd)/metadata.json" .

image=$(jq -r '"\(."image.name")@\(."containerimage.digest")"' metadata.json)
buildkite-agent metadata set "image" "${image}"