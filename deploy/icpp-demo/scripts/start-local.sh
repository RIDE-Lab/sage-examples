#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
docker load -i artifacts/sage-icpp-demo-20260921.tar
docker compose -p sage-icpp-demo-local -f compose.local.yaml up -d --pull never --no-build --wait
echo "Open http://localhost:${LOCAL_DEMO_PORT:-18400}/ui/"
