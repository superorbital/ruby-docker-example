# Buildkite Ruby Docker Example

[![Add to Buildkite](https://buildkite.com/button.svg)](https://buildkite.com/new)

This repository is an example on how to test a [Ruby](https://www.ruby-lang.org/en/) project using [Buildkite](https://buildkite.com/), [Kubernetes Agent Stack](https://github.com/buildkite/agent-stack-k8s/tree/v2), and [Docker](https://docker.com/). It uses the standard [Ruby Docker image](https://hub.docker.com/_/ruby/) and the Buildkite [Kubernetes Agent Stack](https://github.com/buildkite/agent-stack-k8s/tree/v2).

## Setup

### Buildkit Daemon

This pipeline requires two dependencies to replicate the build on the Kubernetes agent stack. First, the buildkitd daemon was configured using the instructions for the Deployment and Service found in [the buildkit repository](https://github.com/moby/buildkit/tree/master/examples/kubernetes). 

```
./create-certs.sh 127.0.0.1 buildkitd.default.svc buildkitd.default buildkitd.default.svc.cluster.local
kubectl apply -f .certs/buildkit-daemon-certs.yaml
kubectl apply -f deployment+service.rootless.yaml
```

The previous instructions also create buildkit client certs Kubernetes secret which need to be used to configure the remote builder. Load that secret into the buildkite agent stack namespace with the following command:

```
kubectl apply -n buildkite -f .certs/buildkite-client-certs.yaml
```

### GHCR Auth

Then, set up authentication to GHCR using a github personal access token.
create a token with access to `packages:read` and `packages:write`.

Base64 encode your github username and token:

```
echo -n "$GITHUB_USERNAME:$GITHUB_TOKEN" | base64
```

Take that result and build a Docker `config.json` file:

```
{
    "auths":
    {
        "ghcr.io":
            {
                "auth":"$BASE64_ENCODED_AUTH"
            }
    }
}
```

Then, use this file to create a secret:

```
kubectl create secret -n buildkite generic dockerconfigjson --from-file=config.json 
```

## License

See [Licence.md](Licence.md) (MIT)
