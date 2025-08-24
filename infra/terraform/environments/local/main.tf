# =============================================================================
# Local Environment Configuration - Professional Setup
# Development setup with Kind cluster
# =============================================================================

locals {
  environment = "local"
  region      = "local"

  common_tags = {
    Environment = local.environment
    ManagedBy   = "terraform"
    Project     = "sparrow"
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

module "logging" {
  source = "../../modules/platform/logging"

  namespace      = "monitoring"
  service_type   = "ClusterIP"
  loki_node_port = 3100

  resources = {
    loki = {
      requests = { memory = "256Mi", cpu = "200m" }
      limits   = { memory = "512Mi", cpu = "400m" }
    }
    alloy = {
      requests = { memory = "128Mi", cpu = "100m" }
      limits   = { memory = "256Mi", cpu = "200m" }
    }
  }

  module_dependencies = [module.monitoring]
  tags                = local.common_tags
}
