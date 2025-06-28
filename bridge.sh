#!/bin/bash

set -e

: "${PHONE_NO:?Env var PHONE_NO is not set, exiting}"
: "${SIGNAL_GROUP_ID:?Env var SIGNAL_GROUP_ID not set, exiting}"
: "${MATTERMOST_WEBHOOK_URL:?Env var MATTERMOST_WEBHOOK_URL not set, exiting}"

signal-cli --version

echo "Bridge running!"
