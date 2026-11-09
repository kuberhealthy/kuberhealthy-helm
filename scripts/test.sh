#!/usr/bin/env bash
set -euo pipefail

chart="charts/kuberhealthy"
release_dir=".cr-release-packages"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

helm lint "$chart"
helm template kuberhealthy "$chart" --namespace kuberhealthy --include-crds > "$tmp_dir/default.yaml"
mkdir -p "$release_dir"
helm package "$chart" --destination "$release_dir"

if grep -q 'docker.io/kuberhealthy/kuberhealthy:main' "$tmp_dir/default.yaml"; then
  echo "default render must not use the mutable main image tag"
  exit 1
fi

helm template kuberhealthy "$chart" \
  --namespace kuberhealthy \
  --set securityContext.enabled=false > "$tmp_dir/no-security-context.yaml"
if grep -q 'allowPrivilegeEscalation:' "$tmp_dir/no-security-context.yaml"; then
  echo "securityContext.enabled=false should omit container securityContext fields"
  exit 1
fi

helm template kuberhealthy "$chart" \
  --namespace kuberhealthy \
  --set podDisruptionBudget.minAvailable=0 > "$tmp_dir/pdb-zero.yaml"
if ! grep -q 'minAvailable: 0' "$tmp_dir/pdb-zero.yaml"; then
  echo "podDisruptionBudget.minAvailable=0 should render minAvailable: 0"
  exit 1
fi

if grep -q 'kind: Ingress' "$tmp_dir/default.yaml"; then
  echo "default render must omit the Ingress"
  exit 1
fi

helm template kuberhealthy "$chart" \
  --namespace kuberhealthy \
  --set ingress.enabled=true \
  > "$tmp_dir/ingress-any-host.yaml"
if grep -q 'host:' "$tmp_dir/ingress-any-host.yaml"; then
  echo "ingress.enabled=true without hosts should render a rule for any host"
  exit 1
fi

helm template kuberhealthy "$chart" \
  --namespace kuberhealthy \
  --set ingress.enabled=true \
  --set ingress.className=nginx \
  --set 'ingress.hosts[0]=kuberhealthy.example.com' \
  --set 'ingress.tls[0].secretName=kuberhealthy-tls' \
  > "$tmp_dir/ingress.yaml"
for want in 'kind: Ingress' 'ingressClassName: nginx' 'host: "kuberhealthy.example.com"' 'secretName: kuberhealthy-tls' 'number: 80'; do
  if ! grep -q "$want" "$tmp_dir/ingress.yaml"; then
    echo "ingress.enabled=true should render an Ingress with $want"
    exit 1
  fi
done

# CRD OpenAPI also names this field; check the live objects only.
helm template kuberhealthy "$chart" --namespace kuberhealthy > "$tmp_dir/no-crds.yaml"
if grep -q 'topologySpreadConstraints:' "$tmp_dir/no-crds.yaml"; then
  echo "default render must omit topologySpreadConstraints"
  exit 1
fi

helm template kuberhealthy "$chart" \
  --namespace kuberhealthy \
  --set-json 'deployment.topologySpreadConstraints=[{"maxSkew":1,"topologyKey":"topology.kubernetes.io/zone","whenUnsatisfiable":"ScheduleAnyway","labelSelector":{"matchLabels":{"app":"kuberhealthy"}}}]' \
  > "$tmp_dir/tsc.yaml"
if ! grep -q 'topologyKey: topology.kubernetes.io/zone' "$tmp_dir/tsc.yaml"; then
  echo "deployment.topologySpreadConstraints should render on the pod spec"
  exit 1
fi
