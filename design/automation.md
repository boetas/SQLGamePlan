# When to Use Ansible vs Terraform in Your Project

Understanding when to use **Ansible** vs **Terraform** in your hybrid cloud + local environment project is key to showcasing your DevOps skills clearly. Here's a practical guide:

---

## When to Use **Terraform**

| Purpose                                | Explanation                                    | Examples in Your Project                      |
|---------------------------------------|------------------------------------------------|----------------------------------------------|
| **Infrastructure Provisioning**       | Create, update, delete cloud resources declaratively | - Create AKS cluster on Azure<br>- Create Azure SQL DB<br>- Setup Azure Blob Storage account |
| **Cloud Resource Lifecycle Management** | Manage cloud infra as code with state tracking | - Scale AKS node pools<br>- Configure virtual networks, firewall rules |
| **Idempotent, Declarative, Immutable** | Terraform applies changes based on desired state | - Recreate resources if drift occurs |

**Summary:** Terraform is your go-to tool for **cloud infrastructure setup and management**.

---

## When to Use **Ansible**

| Purpose                           | Explanation                                  | Examples in Your Project                     |
|----------------------------------|----------------------------------------------|---------------------------------------------|
| **Configuration Management**     | Install/configure software on VMs or containers | - Install PostgreSQL extensions<br>- Configure monitoring agents<br>- Setup OS-level security patches on VM |
| **Application Deployment**       | Deploy apps, run scripts, update services    | - Deploy FastAPI app to AKS or VMs<br>- Manage Kubernetes manifests or Helm charts<br>- Run database schema migrations |
| **Orchestration & Automation**   | Combine tasks across multiple systems         | - Automate backups<br>- Run ETL jobs<br>- Execute complex deployment pipelines |
| **Ad-hoc Tasks & Playbooks**     | Run once-off or repeated operational tasks    | - Restart services<br>- Apply firewall changes on VMs |

**Summary:** Ansible is best for **configuring, deploying, and automating tasks inside your infrastructure**.

---

## Typical Workflow in Your Project

| Step                         | Tool        | Description                                         |
|------------------------------|-------------|-----------------------------------------------------|
| Provision AKS, Azure SQL DB, Blob Storage | Terraform  | Define and create all cloud infrastructure resources |
| Configure AKS Nodes, Install Helm Charts, Deploy FastAPI | Ansible    | Configure nodes, deploy apps and monitoring agents |
| Run Database Migrations, Backup Jobs   | Ansible    | Automate operational tasks and maintenance          |
| Local Docker Setup & App Configuration  | Ansible (optional) | Automate local Docker container setup if needed     |

---

## Why Use Both?

- **Terraform** ensures your cloud resources exist and are in the desired state.
- **Ansible** configures those resources and deploys applications **inside** them.
- Combining both shows you understand **infrastructure as code** (IaC) and **configuration management**.

---

## Bonus: Integrating Ansible and Terraform

- Use Terraform’s `local-exec` or `remote-exec` provisioners to trigger Ansible playbooks after infrastructure creation.
- Manage secrets and credentials securely between tools (Azure Key Vault, HashiCorp Vault).

---

## Summary Table

| Tool       | Role                           | Key Benefits                         | Your Project Usage                           |
|------------|--------------------------------|------------------------------------|----------------------------------------------|
| **Terraform** | Cloud Infra Provisioning       | Declarative, stateful, idempotent  | Provision AKS, Azure SQL, Blob Storage       |
| **Ansible**  | Config & App Deployment         | Procedural, agentless, flexible    | Configure AKS nodes, deploy FastAPI, run ETL |

---

Would you like:

- Sample Terraform configs for AKS + Azure SQL DB?  
- Ansible playbooks to deploy FastAPI and manage Kubernetes?  
- A combined workflow example showing Terraform + Ansible integration?

Let me know!
