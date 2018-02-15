#!/bin/bash

set -e

if [[ ! -f "${ENVOY_SRCDIR}/build_release_stripped/envoy" ]]; then
    echo "could not locate envoy binary at path: ${ENVOY_SRCDIR}/build_release_stripped/envoy"
    
    # TODO(taion809): discuss whether or not failing to publish to github warrents failing the build itself
    exit 0
fi

if [[ -z "${GITHUB_TOKEN}" ]]; then
    echo "environment variable GITHUB_TOKEN unset; cannot continue with publishing."
    
    # TODO(taion809): discuss whether or not failing to publish to github warrents failing the build itself
    exit 0
fi

if [[ -n "${CIRCLE_TAG:-}" ]]; then
    echo "skipping tag events"
    exit 0
fi

TAG=$(git describe --abbrev=0 --tags)

wget https://github.com/aktau/github-release/releases/download/v0.7.2/linux-amd64-github-release.tar.bz2 -O /tmp/ghrelease.tar.bz2
tar -xvjpf /tmp/ghrelease.tar.bz2 -C /tmp
cp /tmp/bin/linux/amd64/github-release /usr/local/bin/ghrelease
chmod +x /usr/local/bin/ghrelease

if [[ -n "${TAG:-}" ]]; then
    ghrelease release --tag "${TAG:-}" --user taion809 --repo envoy-build-tests --name "envoy release ${TAG:-}"
    ghrelease upload --tag "${TAG:-}" --user taion809 --repo envoy-build-tests --name "envoy-linux-amd64" --file "${ENVOY_SRCDIR}/build_release_stripped/envoy"
fi
