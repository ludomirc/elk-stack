#!/bin/bash

echo "⏱️ Checking Kibana logs..."

docker compose logs kibana > kibana.log

echo "==== ⚠️ Kibana Startup Warnings ===="
grep -i "not ready" kibana.log

echo ""
echo "==== ✅ Success Indicators ===="
grep -E "Kibana is starting|Kibana process configured|fleet plugin is now available|http server running" kibana.log

echo ""
echo "==== ❌ Fatal Errors ===="
grep -E "FATAL|shutting down|config validation" kibana.log

echo ""
echo "==== 🔍 Summary ===="
if grep -iq "not ready" kibana.log; then
    echo "⚠️  Kibana is still starting or stuck. Watch logs closely with:"
    echo "    docker compose logs -f kibana"
elif grep -q "FATAL" kibana.log; then
    echo "❌ Kibana failed to start. Fix the errors above."
else
    echo "✅ Kibana appears to be healthy and running."
fi

