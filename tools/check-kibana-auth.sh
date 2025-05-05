#!/bin/bash

echo "🔍 Checking Elasticsearch logs for Kibana auth issues..."

docker compose logs elasticsearch 2>&1 | grep -Ei '"message":.*(kibana_system).*failed to authenticate'

echo "✅ Done."

