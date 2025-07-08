# 🏗️ Full-Stack DBA Portfolio: Azure + Oracle + MongoDB + Kubernetes + Ansible

## 💵 Phase 1: Resource Planning with Azure Budget ($200)

# 💰 Azure Budget Feasibility for Project Design
Your **$200 Azure credit** is sufficient **if you optimize resource usage**.

---

## ✅ What’s in Azure

| Component         | Type                   | Notes                               | Est. Monthly Cost |
|------------------|------------------------|--------------------------------------|-------------------|
| **AKS**          | 1–2 node cluster        | Use **B2s** or **B4ms** node size    | $60–100           |
| **PostgreSQL**   | Helm in AKS             | Free (only uses AKS resources)       | Included in AKS   |
| **MySQL**        | Helm in AKS             | Same as above                        | Included in AKS   |
| **MongoDB**      | Helm in AKS             | Same as above                        | Included in AKS   |
| **Grafana**      | Helm in AKS             | Optional PVC for dashboards          | Included in AKS   |
| **Azure SQL DB** | PaaS (S0 or Basic Tier) | For dashboards/analytics             | ~$5–15            |
| **Blob Storage** | Standard hot tier       | For storing datasets (CSV/JSON)      | <$1               |

---

## 🔗 Phase 2: Hybrid Architecture Design

Summary:
- All containerized databases you run locally (e.g. Oracle XE, SQL Server) live in Docker on your laptop.
- All cloud-based components (PostgreSQL, MySQL, MongoDB, Grafana) live in AKS.
- Ansible (on your laptop) provisions and manages Azure resources.
- ETL / API logic can run either locally (for control) or in AKS (for demo/public exposure).

## 🛠️ Phase 3: Provisioning with Ansible

### Tasks:

- **Provision AKS Cluster**  
  Use `azure_rm_aks` Ansible module

- **Deploy PostgreSQL, MySQL, MongoDB** to AKS via Helm

- **Create Azure Blob Storage**  
  Upload datasets

- **Provision Azure SQL DB**  
  Use `azure_rm_sqlserver` and `azure_rm_sqldatabase` modules

---

## 🧩 Phase 4: ETL & Data Loading Pipelines

### Data Sources:
- Open datasets (FIFA, IPL, NFL, IRB) from Kaggle, APIs, or public sources
- Stored in **Azure Blob Storage**

### Data Targets:

| Database         | Use Case                                    | Loader Tool                 |
|------------------|---------------------------------------------|-----------------------------|
| PostgreSQL       | Structured match stats, rankings            | Python + psycopg2           |
| MySQL            | Historical scores, schedules                | Python + mysql-connector    |
| MongoDB          | Player profiles, event logs (JSON)          | Python + pymongo            |
| Oracle XE        | Financials, stadium data                    | Python + cx_Oracle          |
| Azure SQL DB     | Consolidated analytics dashboard tables     | Python + pyodbc             |
| SQL Server       | Legacy integration or real-time analytics   | Python + pyodbc or pymssql  |

---

## 🧠 Phase 5: Querying & Analytics

- Write SQL for top performers, match trends
- Implement:
  - Stored procedures
  - Indexes
  - Execution plan comparisons across DBs

---

## 🌐 Phase 6: API Layer & Dashboards

### FastAPI (in AKS or locally)

Endpoints:

- `/fifa/top-scorers`
- `/ipl/venue-averages`
- `/nfl/player-profiles`

> Queries multiple databases including MongoDB, PostgreSQL, Azure SQL

### Grafana or Metabase

- Connect to PostgreSQL and Azure SQL DB
- Dashboards:
  - "Team vs Player Performance"
  - "IRB Rankings Over Time"

---

## 🗃️ Phase 7: GitHub Project Structure

```bash
project/
├── ansible/
│   ├── aks_provision.yml
│   ├── az_sql_provision.yml
├── etl/
│   ├── load_postgres.py
│   ├── load_mongodb.py
│   ├── load_oracle.py
│   └── load_azuresql.py
├── api/
│   └── app.py  # FastAPI server
├── k8s/
│   ├── helm-values/
│   └── manifests/
├── dashboards/
│   └── grafana_dashboards.json
├── docs/
│   └── architecture.md
└── README.md
