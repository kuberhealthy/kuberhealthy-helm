# v1.0.1

This corrective release supersedes the initial `v1.0.0` chart package. Use
`v1.0.1` for new installs and upgrades from the first dedicated Kuberhealthy
Helm chart repository release.

## Highlights

- Publishes chart version `1.0.1` from `charts/kuberhealthy`.
- Sets the chart `appVersion` to `v3.0.4` instead of the temporary `main`
  value in the initial `v1.0.0` package.
- Preserves the chart behavior from the existing in-tree Kuberhealthy chart
  while carrying the latest template validation fixes.
- Adds `scripts/test.sh` validation for `helm lint`, `helm template`, chart
  packaging, stable image defaults, and edge-case rendering.
- Adds repository LICENSE and NOTICE files.
- Includes workflow templates for pull request validation and tag-based GitHub
  releases once workflow write permission is enabled for this repo.

## Upgrade notes

`v1.0.0` was published from the first seed commit before the final validation
fixes landed. Its tag and release asset are left in place for immutability, but
the recommended chart release is now `v1.0.1`.

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
