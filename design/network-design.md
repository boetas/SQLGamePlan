# 🌐 Hybrid Network Architecture Design

This design connects your local Docker containers (Oracle XE, SQL Server) with Azure services (AKS, Azure SQL, Blob Storage), using secure public endpoints or optional VPN.

---

## 📊 Architecture Diagram (Text-based)

                  ┌─────────────────────────────────────────────┐
                  │               Azure Cloud                   │
                  │                                             │
                  │  ┌────────────┐   ┌────────────┐            │
                  │  │   AKS      │   │ Azure SQL  │            │
                  │  │ Cluster    │   │ Database   │            │
                  │  │ (Postgres, │   └────────────┘            │
                  │  │ MySQL,     │                             │
                  │  │ MongoDB,   │   ┌────────────┐            │
                  │  │ Grafana)   │   │ Blob Storage│            │
                  │  └────┬───────┘   └────────────┘            │
                  │       │                                     │
                  └───────┼─────────────────────────────────────┘
                          │  (Secure public endpoint or VPN)
                          │
    ┌─────────────────────▼────────────────────┐
    │              Developer Laptop            │
    │                                          │
    │  ┌────────────┐   ┌────────────┐         │
    │  │ Oracle XE  │   │ SQL Server │         │
    │  │  (Docker)  │   │  (Local)   │         │
    │  └────────────┘   └────────────┘         │
    │                                          │
    │  ┌────────────┐                          │
    │  │  Ansible   │ (provision Azure)        │
    │  └────────────┘                          │
    │  ┌────────────┐                          │
    │  │  FastAPI   │ (can run here or in AKS) │
    │  └────────────┘                          │
    └──────────────────────────────────────────┘


---

## 📶 Network Design Components

| Layer             | Description                                                                 |
|------------------|-----------------------------------------------------------------------------|
| **Local Docker**  | Runs Oracle XE and SQL Server, accessible via `localhost` or `host.docker.internal` |
| **Ansible**       | Runs from the host, uses `az` CLI + Azure Python SDK for provisioning Azure |
| **AKS**           | Hosts PostgreSQL, MySQL, MongoDB, Grafana, and optionally FastAPI           |
| **Public/Private Access** | AKS exposes services via LoadBalancer or Ingress with TLS           |
| **Firewall Rules**| Azure SQL and Blob Storage allow traffic from your laptop’s IP              |

---

## 🔒 Security Best Practices

| Component         | Recommendation                                          |
|------------------|---------------------------------------------------------|
| Azure SQL DB      | Add your laptop IP to firewall exceptions              |
| Blob Storage      | Use SAS tokens or Private Endpoints                    |
| AKS API access    | Use `az aks get-credentials` securely from host        |
| AKS services      | Use Ingress + HTTPS (NGINX)                            |
| Docker containers | Bind ports only to `127.0.0.1`                         |

---

## 📦 Connectivity Scenarios

| From (Source)    | To (Target)       | Method                             |
|------------------|-------------------|------------------------------------|
| FastAPI (Local)  | AKS DBs           | Public LoadBalancer IP or Ingress |
| FastAPI (in AKS) | MongoDB/Postgres  | Internal DNS (`svc.namespace.svc.cluster.local`) |
| ETL Scripts      | Azure SQL DB      | pyodbc via public endpoint         |
| ETL Scripts      | Blob Storage      | Azure SDK (with key or SAS token) |
| Ansible Host     | Azure API         | Auth via `az login` or service principal |

---

## ✅ Summary

- Run Oracle XE and SQL Server locally in Docker.
- Host cloud services (PostgreSQL, MySQL, MongoDB, Grafana) in AKS.
- Use public endpoints with IP restrictions or VPN.
- Ansible manages provisioning from your laptop.
- FastAPI can bridge between local and cloud as needed.

---

## Application connectivity
You should use a Python virtual environment on your laptop to:
- Access local Docker databases (Oracle, SQL Server)
- Access AKS-hosted services via LoadBalancer IPs
- Access Azure SQL DB by whitelisting your IP
- Connect to Azure Blob Storage using the SDK