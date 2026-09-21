#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
docker compose -p sage-icpp-demo-hub -f compose.hub.yaml pull
docker compose -p sage-icpp-demo-hub -f compose.hub.yaml up -d --pull never --no-build --wait
echo "Open http://localhost:${LOCAL_DEMO_PORT:-18400}/ui/"
