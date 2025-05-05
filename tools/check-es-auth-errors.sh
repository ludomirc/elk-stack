#!/bin/bash

echo "🔍 Checking Elasticsearch logs for authentication issues..."

docker compose logs elasticsearch 2>&1 | grep -Ei "kibana_system|authentication failed|no such user|unauthorized|security_exception"

echo "✅ Done."

