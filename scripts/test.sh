#!/usr/bin/env sh
set -eu

chart="charts/kuberhealthy"
release_dir=".cr-release-packages"

helm lint "$chart"
helm template kuberhealthy "$chart" --namespace kuberhealthy >/tmp/kuberhealthy-helm-template.yaml
mkdir -p "$release_dir"
helm package "$chart" --destination "$release_dir"
