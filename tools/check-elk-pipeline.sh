#!/bin/bash

echo "🔍 Checking ELK pipeline..."

# 1. Check Filebeat logs for Logstash connection
echo -e "\n📦 Filebeat → Logstash connection:"
docker compose logs --tail 30 filebeat 2>/dev/null | grep -Ei 'logstash|error|connected' || echo "⚠️ No recent Filebeat logs"

# 2. Check Logstash logs for incoming events and Elasticsearch output
echo -e "\n📤 Logstash activity:"
docker compose logs --tail 30 logstash 2>/dev/null | grep -Ei 'pipeline|elasticsearch|error|event' || echo "⚠️ No recent Logstash logs"

# 3. Manually append a test log to trigger ingestion
TEST_LOG="logs/test.log"
mkdir -p logs
echo "{\"message\": \"test log entry\", \"level\": \"info\", \"timestamp\": \"$(date -Is)\"}" >> "$TEST_LOG"
echo "📝 Wrote test log entry to $TEST_LOG"

# 4. Wait for processing
echo "⏳ Waiting 10 seconds for Filebeat → Logstash → Elasticsearch pipeline..."
sleep 10

# 5. Check for created indices in Elasticsearch
echo -e "\n📊 Elasticsearch indices:"
curl -s -u logstash_ingest:YourStrongPassword http://localhost:9200/_cat/indices?v || echo "❌ Could not query Elasticsearch"

echo -e "\n✅ Done."


