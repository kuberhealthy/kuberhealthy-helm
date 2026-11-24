# v1.2.0

This feature release adds optional integrations and configuration for exposing
Kuberhealthy metrics, alerts, service access, and workload identity. Use
`v1.2.0` for new installs and upgrades from the `v1.1.x` chart line.

## Highlights

- Publishes chart version `1.2.0` from `charts/kuberhealthy`.
- Adds an optional Prometheus Operator `ServiceMonitor` for scraping the
  Kuberhealthy metrics endpoint.
- Adds an optional Prometheus Operator `PrometheusRule` with alerts for failing
  and stale HealthChecks, plus support for additional rules.
- Adds optional `ServiceAccount` annotations for integrations such as AWS IRSA
  and GKE Workload Identity.
- Adds an optional `Ingress` with configurable class, annotations, hosts, TLS,
  and service path settings.
- Retains the optional `deployment.topologySpreadConstraints` support from
  `v1.1.0`.

## Upgrade notes

No values migration is required. Existing `v1.1.x` installations retain their
current behavior because all new integrations are disabled by default. Enable
the features you need in your Helm overrides. For example:

```yaml
serviceMonitor:
  enabled: true
  additionalLabels:
    release: kube-prometheus-stack

prometheusRule:
  enabled: true

serviceAccount:
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::123456789012:role/kuberhealthy

ingress:
  enabled: true
  className: nginx
  hosts:
    - kuberhealthy.example.com
```

The `ServiceMonitor` and `PrometheusRule` resources require the corresponding
Prometheus Operator CRDs. Configure `service.externalPort` and `ingress.path`
to match any custom service exposure requirements.

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
