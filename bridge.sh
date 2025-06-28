#!/bin/bash

set -e

: "${PHONE_NO:?Env var PHONE_NO is not set, exiting}"
: "${SIGNAL_GROUP_ID:?Env var SIGNAL_GROUP_ID not set, exiting}"
: "${MATTERMOST_WEBHOOK_URL:?Env var MATTERMOST_WEBHOOK_URL not set, exiting}"

echo "Starting bridge..."

signal-cli --version

signal-cli -u "$PHONE_NO" receive | while read -r line; do
  echo "Sending to Mattermost: $line"
  curl -X POST -H 'Content-Type: application/version' \
    -d "{\"text\": \"$line\"}" \
    "$MATTERMOST_WEBHOOK_URL"
done
