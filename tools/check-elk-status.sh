#!/bin/bash

echo "🔍 Checking ELK stack status..."

# Check Elasticsearch health
echo -e "\n📦 Elasticsearch cluster health:"
docker compose exec elasticsearch curl -s http://localhost:9200/_cluster/health?pretty || echo "❌ Cannot reach Elasticsearch"

# Check if Elasticsearch is reachable from Kibana
echo -e "\n🔗 Connectivity: Kibana → Elasticsearch:"
docker compose exec kibana curl -s http://elasticsearch:9200 | grep tagline || echo "❌ Kibana cannot reach Elasticsearch"

# Check if Kibana is running and accessible
echo -e "\n📊 Kibana HTTP server status:"
docker compose logs kibana 2>&1 | grep -i "http server running" || echo "❌ Kibana HTTP server not detected"

# Look for fatal errors
echo -e "\n🚨 Kibana fatal errors:"
docker compose logs kibana 2>&1 | grep -i fatal || echo "✅ No fatal errors found"

# Check if Kibana is listening on the expected port
echo -e "\n🌐 Kibana port check (5601):"
docker compose ps | grep kibana

# Optional: show Kibana last lines
echo -e "\n📄 Last 10 Kibana log lines:"
docker compose logs kibana --tail=10

# System memory check
echo -e "\n🧠 System memory usage:"
free -h

# Docker container resource stats
echo -e "\n📊 Docker container stats:"
docker stats --no-stream

echo -e "\n✅ Done."

