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


