# 🚀 Sparrow - Enterprise Architecture

> **Monorepo** with enterprise-grade architecture for high-availability systems

## ⚡ **Quick Start**

### **1. Prerequisites**

```bash
# Install tools
brew install kubectl helm terraform kind kubectx k9s
```
### **2. Create Cluster**

```bash
# Install tools
kind create cluster --name sparrow
```

### **3. Cluster Setup**

```bash
# Check current cluster context and list
kubectx

# Switch to desired cluster (if using kubectx)
kubectx <cluster-name>
```

### **4. Configuration**

```bash
# Configure Terraform settings
vim infra/terraform/environments/local/terraform.tfvars
```

**Key Settings to Update:**
```bash
# In terraform.tfvars file
cluster_name = "your-cluster-name"  # Update to your cluster name
argocd_admin_password = "your-password"  # Change default password
```

### **4. Setup**

```bash
# Complete setup (uses current cluster context)
make full
```

### **5. Access**

- **ArgoCD**: http://localhost:30080 (admin/admin123)
- **Grafana**: http://localhost:30000 (admin/admin)
- **Prometheus**: http://localhost:30001

## 🏗️ **Architecture**

### **📦 Hybrid Strategy**

- **🐳 Docker Compose**: Data infrastructure (PostgreSQL, Redis, Redpanda)
- **🏗️ Terraform**: Kubernetes platform (ArgoCD, Prometheus, Grafana)
- **☸️ Kubernetes**: Orchestration and observability

## 📋 **Commands**

### **🐳 Data**

```bash
make data          # Start databases
make data-down     # Stop databases
make data-destroy  # Destroy data
make logs          # View logs
```

### **🏗️ Platform**

```bash
make platform      # Deploy platform
make platform-plan # Plan changes
make platform-destroy # Destroy platform
```

### **📊 Monitoring**

```bash
make monitor       # Open dashboards
make check         # Check status
```

### **🗑️ Destruction**

```bash
make destroy       # Destroy platform and data (keeps cluster)
make clean         # Soft cleanup
```

## 🌐 **Services**

### **Data Infrastructure**

- **PostgreSQL**: `localhost:5432`
- **Redis**: `localhost:6379`
- **Redpanda**: `localhost:9092`

### **Platform**

- **ArgoCD**: `http://localhost:30080` (admin/admin123)
- **Grafana**: `http://localhost:30000` (admin/admin)
- **Prometheus**: `http://localhost:30001`

## 📁 **Structure**

```
system-design/
├── apps/                    # Applications
├── infra/                   # Infrastructure
│   ├── terraform/          # Terraform IaC
│   └── docker/             # Docker configs
├── load/                    # Load testing
├── scripts/                 # Scripts
└── docs/                    # Documentation
```
