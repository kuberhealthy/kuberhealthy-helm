# v1.0.0

This is the first independently versioned release of the Kuberhealthy Helm
chart. The chart has moved from `kuberhealthy/kuberhealthy` into this dedicated
repository so Helm chart changes can be tagged and released separately from the
main Kuberhealthy application.

## Highlights

- Publishes chart version `1.0.0` from `charts/kuberhealthy`.
- Preserves the chart behavior from the existing in-tree Kuberhealthy chart.
- Adds `scripts/test.sh` validation for `helm lint`, `helm template`, and chart
  packaging.
- Includes workflow templates for future pull request validation and tag-based
  GitHub releases once workflow write permission is enabled for this repo.

## Migration

Users installing from a local checkout should update commands from:

```sh
helm install kuberhealthy deploy/helm/kuberhealthy -n kuberhealthy --create-namespace
```

to:

```sh
git clone https://github.com/kuberhealthy/kuberhealthy-helm.git
helm install kuberhealthy ./kuberhealthy-helm/charts/kuberhealthy -n kuberhealthy --create-namespace
```

No Kuberhealthy application image change is included in this chart-only
release.
