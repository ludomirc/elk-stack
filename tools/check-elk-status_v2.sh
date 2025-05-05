#!/bin/bash

# === CONFIG ===
ES_URL="http://localhost:9200"
KIBANA_URL="http://localhost:5601"
ES_TOKEN="AAEAAWVsYXN0aWMva2liYW5hL215LWtpYmFuYS10b2tlbjpDcXdPMHR0WVRBS3UyMEc2cjZLWm1B"
KIBANA_CONTAINER="elk-stack-kibana-1"
ES_CONTAINER="elk-stack-elasticsearch-1"

echo "🔍 Checking ELK stack health..."

# Check Elasticsearch status
echo -e "\n📦 Elasticsearch cluster health:"
curl -s -H "Authorization: Bearer $ES_TOKEN" "$ES_URL/_cluster/health?pretty" || echo "❌ Failed to reach Elasticsearch"

# Check if Elasticsearch is reachable from Kibana
echo -e "\n🔗 Kibana → Elasticsearch connection check:"
docker compose logs "$KIBANA_CONTAINER" 2>&1 | grep -i "elasticsearch-service" | tail -n 5

# Check if Kibana is running
echo -e "\n📊 Kibana server status:"
docker compose logs "$KIBANA_CONTAINER" 2>&1 | grep -i "http server running"

# Look for any fatal errors in Kibana
echo -e "\n🚨 Kibana fatal errors:"
docker compose logs "$KIBANA_CONTAINER" 2>&1 | grep -i fatal || echo "✅ No fatal errors found"

# Show recent errors or warnings
echo -e "\n⚠️ Recent Kibana warnings/errors:"
docker compose logs "$KIBANA_CONTAINER" 2>&1 | grep -Ei "warn|error" | tail -n 10

# Optional: Port check
echo -e "\n🌐 Port check:"
ss -tuln | grep ':5601' && echo "✅ Kibana port 5601 is open" || echo "❌ Kibana port 5601 not open"

echo -e "\n✅ Done."

