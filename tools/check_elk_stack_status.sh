#!/bin/bash

# Function to check if the container is running
check_container_status() {
    container_name=$1
    status=$(docker inspect -f '{{.State.Status}}' $container_name)
    if [ "$status" == "running" ]; then
        echo "$container_name is running."
    else
        echo "$container_name is NOT running!"
    fi
}

# Function to check Elasticsearch status
check_elasticsearch() {
    echo "🔍 Checking Elasticsearch status..."
    response=$(curl -s -u elastic:$ELASTIC_PASSWORD http://localhost:9200/_cluster/health?pretty)
    status=$(echo $response | jq -r '.status')
    echo "Cluster health status: $status"
    
    # Check Elasticsearch indices
    echo "🔍 Checking Elasticsearch indices..."
    curl -s -u elastic:$ELASTIC_PASSWORD http://localhost:9200/_cat/indices?v | head -n 20
}

# Function to check Kibana status
check_kibana() {
    echo "🔍 Checking Kibana status..."
    response=$(curl -s -u elastic:$ELASTIC_PASSWORD http://localhost:5601/api/status)
    status=$(echo $response | jq -r '.status.overall.status')
    echo "Kibana status: $status"
}

# Function to check Logstash logs
check_logstash() {
    echo "🔍 Checking Logstash status..."
    logstash_logs=$(docker logs elk-stack-logstash-1 | tail -n 20)
    echo "Last 20 Logstash log entries:"
    echo "$logstash_logs"
}

# Function to check Filebeat logs
check_filebeat() {
    echo "🔍 Checking Filebeat status..."
    filebeat_logs=$(docker logs elk-stack-filebeat-1 | tail -n 20)
    echo "Last 20 Filebeat log entries:"
    echo "$filebeat_logs"
}

# Function to check the connection between Filebeat and Logstash
check_filebeat_logstash_connection() {
    echo "🔍 Checking Filebeat → Logstash connection..."
    filebeat_logs=$(docker logs elk-stack-filebeat-1 | grep -i "connection refused")
    if [[ -z "$filebeat_logs" ]]; then
        echo "Filebeat → Logstash connection is OK."
    else
        echo "Filebeat → Logstash connection failed!"
        echo "$filebeat_logs"
    fi
}

# Function to check Elasticsearch logs for authentication errors
check_elasticsearch_authentication() {
    echo "🔍 Checking Elasticsearch authentication logs..."
    auth_logs=$(docker logs elk-stack-elasticsearch-1 | grep -i "authentication failed")
    if [[ -z "$auth_logs" ]]; then
        echo "No authentication issues found in Elasticsearch."
    else
        echo "Authentication issues found in Elasticsearch:"
        echo "$auth_logs"
    fi
}

# Collecting report
echo "=== ELK Stack Configuration Report ==="
check_container_status "elk-stack-elasticsearch-1"
check_container_status "elk-stack-kibana-1"
check_container_status "elk-stack-logstash-1"
check_container_status "elk-stack-filebeat-1"

check_elasticsearch
check_kibana
check_logstash
check_filebeat
check_filebeat_logstash_connection
check_elasticsearch_authentication

echo "=== End of Report ==="

