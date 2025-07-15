# 🏆 SQL DBA Sports Data Project Plan

## ✅ Phase 1: Data Preparation & Planning

### 1. **Identify and Download Datasets**
Look for open datasets (CSV, JSON, APIs) for:

- **FIFA** – e.g., player stats, team rankings (Kaggle or FIFA’s developer portal)
- **IPL** – player and match data (Cricsheet, Kaggle)
- **NFL** – play-by-play data (nflfastR, ESPN)
- **IRB (Rugby)** – rankings, match results (World Rugby site or APIs)

Organize them into folders:
data/
├── fifa/
├── ipl/
├── nfl/
└── irb/

---

## ✅ Phase 2: Set Up Databases

### 2. **Local SQL Server**
- Create a database for each sport or a unified `SportsDB`
- Use `SQL Server Management Studio` or `Azure Data Studio`
- Load CSV data via `BULK INSERT` or SSIS

### 3. **Minikube – Host Other DBMSs**

Deploy databases on Minikube using Helm charts or Docker manifests:

| Database     | Helm Chart / Image                | Helm Command (example)                     |
|--------------|-----------------------------------|---------------------------------------------|
| PostgreSQL   | `bitnami/postgresql`              | `helm install pg bitnami/postgresql`       |
| MySQL        | `bitnami/mysql`                   | `helm install mysql bitnami/mysql`         |
| MongoDB      | `bitnami/mongodb`                 | `helm install mongo bitnami/mongodb`       |
| Oracle XE    | Custom Docker image               | Use StatefulSet or Pod deployment manually |

> 💡 Tip: Use PersistentVolumes and expose DBs via `NodePort` or `LoadBalancer`.

---

## ✅ Phase 3: ETL – Load Data into Databases

### 4. **Write ETL Scripts (Python or SQL)**

Write reusable ETL pipelines for each DB engine using:

- `pymssql` for SQL Server
- `psycopg2` or `SQLAlchemy` for PostgreSQL
- `mysql-connector-python` for MySQL
- `cx_Oracle` for Oracle
- `pymongo` for MongoDB

✔ Example: Normalize IPL match CSV into relational tables for SQL Server and insert semi-structured JSON into MongoDB.

---

## ✅ Phase 4: Querying, Indexing & Optimization

### 5. **Write Showcase Queries**
- Analytical queries: Top scorers, win/loss ratios, venue stats, etc.
- Create views, stored procedures, and indexes
- Compare:
  - Performance across engines
  - SQL vs NoSQL (joins vs document structure)

---

## ✅ Phase 5: Visualization & API

### 6. **Visualization**
- Use **Grafana** (in Minikube) to connect to PostgreSQL/MySQL
- Use **Power BI/Tableau** for SQL Server
- Optional: Deploy **Metabase** or **Apache Superset** in Kubernetes

### 7. **Expose APIs (Optional)**
Use Python (FastAPI) or Node.js to expose endpoints like:

- `/top-players/fifa`
- `/match-stats/ipl`

Run API containers in Kubernetes Pods.

---

## ✅ Phase 6: Portfolio & Documentation

### 8. **Document Your Setup**
Create a GitHub repo with:

- Docker/Helm manifests
- SQL schemas and ETL scripts
- Sample dashboards
- Dataset references

### 9. **Write a Blog or LinkedIn Post**
Share your experience and compare engines:

- Oracle XE in Kubernetes
- Indexing large datasets
- MongoDB for unstructured player profiles

---

## 🧠 Bonus Learning Opportunities

- **CI/CD for DB changes** with Flyway or Liquibase
- **Database auditing**: `pgAudit`, SQL Server Extended Events
- **Backup/Restore in Kubernetes**: `velero` or manual PVC backups

---

