# =============================================================================
# Local Environment Configuration Values
# =============================================================================

# Cluster configuration
cluster_name = "kind-sparrow"

# Security
argocd_admin_password  = "admin123"
grafana_admin_password = "admin"

# Features
enable_ingress = false

# Resource limits for local development
resource_quotas = {
  cpu_limit    = "2"
  memory_limit = "4Gi"
  pod_limit    = "50"
}
