# =============================================================================
# Local Environment Configuration
# Development setup with Kind cluster
# =============================================================================

locals {
  environment = "local"
  region      = "local"

  common_tags = {
    Environment = local.environment
    ManagedBy   = "terraform"
    Project     = "system-design"
  }

  # Generate bcrypt hash for ArgoCD admin password
  argocd_password_hash = bcrypt(var.argocd_admin_password)
}

# =============================================================================
# PLATFORM MODULES
# =============================================================================

module "argocd" {
  source = "../../modules/platform/argocd"

  namespace       = "argocd"
  release_name    = "argocd"
  admin_password  = local.argocd_password_hash
  service_type    = "NodePort"
  node_port       = 30080
  ingress_enabled = false

  resources = {
    server = {
      requests = { memory = "128Mi", cpu = "100m" }
      limits   = { memory = "256Mi", cpu = "200m" }
    }
    repoServer = {
      requests = { memory = "128Mi", cpu = "100m" }
      limits   = { memory = "256Mi", cpu = "200m" }
    }
  }

  tags = local.common_tags
}

module "monitoring" {
  source = "../../modules/platform/monitoring"

  namespace        = "monitoring"
  grafana_password = var.grafana_admin_password
  service_type     = "NodePort"

  # Enable NodePort for local development
  grafana_node_port    = 30000
  prometheus_node_port = 30001

  resources = {
    grafana = {
      requests = { memory = "128Mi", cpu = "100m" }
      limits   = { memory = "256Mi", cpu = "200m" }
    }
    prometheus = {
      requests = { memory = "128Mi", cpu = "100m" }
      limits   = { memory = "256Mi", cpu = "200m" }
    }
  }

  tags = local.common_tags
}

# module "logging" {
#   source = "../../modules/platform/logging"
#   
#   namespace      = "monitoring"
#   service_type   = "NodePort"
#   loki_node_port = 3100
#   
#   resources = {
#     loki = {
#       requests = { memory = "128Mi", cpu = "100m" }
#       limits   = { memory = "256Mi", cpu = "200m" }
#     }
#     promtail = {
#       requests = { memory = "64Mi", cpu = "50m" }
#       limits   = { memory = "128Mi", cpu = "100m" }
#     }
#   }
#   
#   module_dependencies = [module.monitoring]
#   tags       = local.common_tags
# }
