
# 🐳 ELK Stack with Docker

This project sets up a full **ELK stack (Elasticsearch, Logstash, Kibana)** along with **Filebeat** using Docker Compose. It's designed for monitoring and visualizing application logs.

---

## 📦 Components

- **Elasticsearch** – Stores and indexes logs.
- **Logstash** – Processes and forwards logs.
- **Kibana** – Web UI for searching and visualizing logs.
- **Filebeat** – Lightweight log shipper.

---

## 📁 Project Structure

```
elk-stack/
├── docker-compose.yml          # Compose file to run all services
├── logstash/
│   └── logstash.conf           # Logstash pipeline configuration
├── filebeat/
│   └── filebeat.yml            # Filebeat configuration
└── logs/
    └── app.log                 # Example log file to be monitored
```

---

## 🚀 Getting Started

### 1. Clone the repo

```bash
git clone https://github.com/yourname/elk-stack-docker.git
cd elk-stack-docker
```

### 2. Start the ELK Stack

```bash
docker-compose up --build
```

Wait a few moments until all services are up.

### 3. Access Kibana

Open your browser and go to:

```
http://localhost:5601
```

---

## 🔍 Setup in Kibana

1. Go to **Discover**
2. Create an **index pattern**:
   - Name: `app-logs-*` (or `filebeat-*` depending on config)
   - Timestamp field: `@timestamp`
3. Start exploring your logs.

---

## 🧪 Testing

To test log shipping:

- Append a new line to `logs/app.log`:
  ```bash
  echo '{"@timestamp":"2024-05-02T12:00:00Z","message":"Hello ELK","level":"INFO"}' >> logs/app.log
  ```

Logs should appear in Kibana after a few seconds.

---

## 📦 Requirements

- Docker
- Docker Compose
- 4 GB+ RAM (for smooth running)

---

## 📌 Notes

- This setup is for **development or local testing**.
- For production: secure ports, enable TLS, and configure proper resource limits.

---

## 🧹 Cleanup

```bash
docker-compose down -v
```

---

## 📄 License

MIT
