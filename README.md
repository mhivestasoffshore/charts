# MHI Vestas Public Helm Charts

Repository contains a number of public Helm Charts maintained by MHI Vestas.

* [kafdrop](charts/kafdrop)
* [loki](charts/loki)
* [promxy](charts/promxy)

![CI](https://github.com/mhivestasoffshore/charts/workflows/CI/badge.svg)

## Build using Bazel

Generate Helm chart packages activating the package target, e.g.:

```sh
bazel build //charts/loki:package
```

Generate repository index like so:

```sh
bazel build :generate_index
```

The resulting output is in `bazel-bin/generate_index`. This should be copied to docs and pushed to GitHub for deployment.
