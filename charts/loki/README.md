# Grafana Loki Helm Chart

Installs Grafana Loki in production setup - basically a Helm version of [Grafana Loki ksonnet deployment](https://github.com/grafana/loki/tree/master/production/ksonnet/loki). All default values are adjusted to
fit the ksonnet deployment.

Promtail can be deployed from the [Grafana Promtail chart](https://github.com/grafana/loki/tree/master/production/helm).

The only storage configuration currently support is Cassandra for indexing and Azure Storage Account for
chunk storage.

## Prerequisites

Add the MHI Vestas Offshore Wind public charts repository.

```sh
helm repo add mvow https://mhivestasoffshore.github.io/charts/
```

## Deploy Grafana Loki

```sh
helm upgrade --install loki
```

## Configuration

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `config.grpc_server_max_msg_size` | Setting max grpc message between components | `104857600` |
| `config.querierConcurrency` | Concurrency setting for querier | `16` |
| `config.http_listen_port` | HTTP port of components listening for http trafic | `80` |
| `config.htpasswd_contents` | Entry for `htpasswd` file of gateway nginx | `loki/password` |
| `config.replication_factor` | Replication factor for ingestor | `3` |
| `config.index_period_hours` | Retention period (168h ~ 30 days) | `168` |
| `config.cassandra.addresses` | Addresses for Cassandra cluster to store index | `''` |
| `config.azure.account_name` | Azure Storage Account name | `''` |
| `config.azure.container_name` | Azure Storage Account blob container name (must be created in advance) | `''` |
| `config.azure.account_key` | Access key for Azure Storage Account | `''` |
| `distributor.name` | Name used to identify the distributor component in Kubernetes manifests, e.g., labels | `distributor` |
| `distributor.replicaCount` | Number of distributor replicas | `3` |
| `distributor.image.repository` | Docker repository for distributor | `grafana/loki` |
| `distributor.image.tag` | Docker tag for distributor | `1.5.0` |
| `distributor.affinity` | Affinity configuration for the distributor - default is preferred to not be scheduled on same node | |
| `distributor.resources` | Resources configuration for the distributor - default is requests `500m/500Mi` limits `1/1Gi` | |
| `ingester.name` | Name used to identify the ingester component in Kubernetes manifests, e.g., labels | `ingester` |
| `ingester.replicaCount` | Number of ingester replicas | `3` |
| `ingester.image.repository` | Docker repository for ingester | `grafana/loki` |
| `ingester.image.tag` | Docker tag for ingester | `1.5.0` |
| `ingester.affinity` | Affinity configuration for the ingester - default is preferred to not be scheduled on same node | |
| `ingester.resources` | Resources configuration for the ingester - default is requests `1/5Gi` limits `2/10Gi` | |
| `querier.name` | Name used to identify the querier component in Kubernetes manifests, e.g., labels | `querier` |
| `querier.replicaCount` | Number of querier replicas | `3` |
| `querier.image.repository` | Docker repository for querier | `grafana/loki` |
| `querier.image.tag` | Docker tag for querier | `1.5.0` |
| `querier.affinity` | Affinity configuration for the querier - default is preferred to not be scheduled on same node | |
| `querier.resources` | Resources configuration for the ingester | `{}` |
| `query_frontend.name` | Name used to identify the query frontend component in Kubernetes manifests, e.g., labels | `query-frontend` |
| `query_frontend.replicaCount` | Number of query frontend replicas | `2` |
| `query_frontend.image.repository` | Docker repository for query frontend | `grafana/loki` |
| `query_frontend.image.tag` | Docker tag for query frontend | `1.5.0` |
| `query_frontend.affinity` | Affinity configuration for the query frontend - default is preferred to not be scheduled on same node | |
| `query_frontend.resources` | Resources configuration for the query frontend - default is requests `2/600Mi` limits `1200Mi` | |
| `table_manager.name` | Name used to identify the table manager component in Kubernetes manifests, e.g., labels | `table-manager` |
| `table_manager.replicaCount` | Number of table manager replicas | `1` |
| `table_manager.image.repository` | Docker repository for table manager | `grafana/loki` |
| `table_manager.image.tag` | Docker tag for table manager | `1.5.0` |
| `table_manager.resources` | Resources configuration for the table manager - default is requests `100m/100Mi` limits `200m/200Mi` | |
| `gateway.name` | Name used to identify the gateway component in Kubernetes manifests, e.g., labels | `gateway` |
| `gateway.replicaCount` | Number of gateway replicas | `2` |
| `gateway.image.repository` | Docker repository for gateway | `nginx` |
| `gateway.image.tag` | Docker tag for gateway | `1.15.1-alpine` |
| `gateway.resources` | Resources configuration for the gateway - default is requests `10m/100Mi` | |
| `memcached.*` | memcached subchart used for caching chunks - defaults set to match the ksonnet scripts | |
| `memcached-index-queries.*` | memcached subchart used for caching index queries - defaults set to match the ksonnet scripts | |
| `memcached-index-writes.*` | memcached subchart used for caching index writes - defaults set to match the ksonnet scripts | |
| `memcached-frontend.*` | memcached subchart used for frontend caching - defaults set to match the ksonnet scripts | |
| `consul.*` | Consul subchart - using defaults from chart | |
