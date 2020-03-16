# Promxy Chart

Helm Chart to easily deploy [Promxy](https://github.com/jacksontj/promxy).

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `image.repository` | Image repository | `quay.io/jacksontj/promxy` |
| `image.tag`        | Image tag to deploy | `v0.0.58` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `replicaCount`     | Number of POD replicas to deploy | `1` |
| `resources`        | Promxy resource requests and limits | `{}` |
| `config`           | Promxy YAML configuration | see `values.yaml` |

