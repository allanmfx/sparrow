# =============================================================================
# Local Environment Variables
# =============================================================================

variable "cluster_name" {
  description = "Name of your existing Kubernetes cluster"
  type        = string
  default     = "kind-sparrow"
}

variable "argocd_admin_password" {
  description = "ArgoCD admin password"
  type        = string
  default     = "admin123"
  sensitive   = true
}

variable "grafana_admin_password" {
  description = "Grafana admin password"
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "enable_ingress" {
  description = "Enable ingress controller"
  type        = bool
  default     = false
}

variable "resource_quotas" {
  description = "Resource quotas for local development"
  type = object({
    cpu_limit    = string
    memory_limit = string
    pod_limit    = string
  })
  default = {
    cpu_limit    = "2"
    memory_limit = "4Gi"
    pod_limit    = "50"
  }
}
