#!/bin/bash

set -euxo pipefail

apk add jq

docker buildx create --name remote --driver remote --driver-opt cacert=/buildkit/certs/ca.pem,cert=/buildkit/certs/cert.pem,key=/buildkit/cert
s/key.pem tcp://buildkitd.default.svc:1234
docker buildx use remote
docker buildx build --tag=ttl.sh/buildkite-ruby-sample:5m --platform=linux/arm64 --push --metadata-file=$(pwd)/metadata.json .

image=$(cat metadata.json | jq -r '"\(."image.name")@\(."containerimage.digest")"'
buildkite-agent metadata set "image" "${image}"
