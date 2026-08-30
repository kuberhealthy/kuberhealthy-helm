# v1.1.0

This feature release adds optional Kubernetes topology spread constraints to
the Kuberhealthy deployment. Use `v1.1.0` for new installs and upgrades from
the `v1.0.x` chart line.

## Highlights

- Publishes chart version `1.1.0` from `charts/kuberhealthy`.
- Adds the optional `deployment.topologySpreadConstraints` value and renders
  it on the Kuberhealthy pod specification when configured.
- Keeps the default scheduling behavior unchanged when the value is empty.
- Includes chart validation for both the default render and an example zone
  spread constraint configuration.

## Upgrade notes

No values migration is required. Existing `v1.0.x` installations retain their
current scheduling behavior because `deployment.topologySpreadConstraints`
defaults to an empty list. To enable topology spreading, set the value in your
Helm overrides, for example:

```yaml
deployment:
  topologySpreadConstraints:
    - maxSkew: 1
      topologyKey: topology.kubernetes.io/zone
      whenUnsatisfiable: ScheduleAnyway
      labelSelector:
        matchLabels:
          app: kuberhealthy
```

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
release. The chart `appVersion` remains `v3.0.5`.
