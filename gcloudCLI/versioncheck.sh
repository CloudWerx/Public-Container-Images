#!/bin/bash
# https://stackoverflow.com/questions/51957958/how-to-find-largest-group-of-numbers-in-a-string-in-bash
latestversion=$(curl -sL https://cloud.google.com/sdk/docs/release-notes | grep -oE '[0-9][0-9][0-9]\.[0-9]\.[0-9]' | sort -n | tail -n 1)
gcloudversion=$(gcloud container images list-tags us-central1-docker.pkg.dev/public-cloudwerx-artifactory/cwx-public-images/gcloud --format="value(tags)" --filter=tags:latest | grep -oE '[0-9][0-9][0-9]\.[0-9]\.[0-9]') #
echo -e "Current gcloud image: $gcloudversion\nLatest release: $latestversion"

#projects/569590385756/locations/global/workloadIdentityPools/github-workload-pool/providers/github-provider