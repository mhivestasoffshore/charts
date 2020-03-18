# MHI Vestas Public Helm Charts

Repository contains a number of public Helm Charts maintained by MHI Vestas.

## Current (Manual) Deployment

```sh
helm package charts/promxy -d docs
cd docs
helm repo index --url https://mhivestasoffshore.github.io/charts/ --merge index.yaml .
```
