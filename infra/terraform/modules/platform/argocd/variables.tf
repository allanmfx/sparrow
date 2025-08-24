# =============================================================================
# ArgoCD Module Variables
# =============================================================================

variable "namespace" {
  description = "Kubernetes namespace for ArgoCD"
  type        = string
  default     = "argocd"
}

variable "create_namespace" {
  description = "Whether to create the namespace"
  type        = bool
  default     = true
}

variable "release_name" {
  description = "Helm release name"
  type        = string
  default     = "argocd"
}

variable "chart_version" {
  description = "ArgoCD Helm chart version"
  type        = string
  default     = "5.51.6"
}

variable "admin_password" {
  description = "ArgoCD admin password"
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "service_type" {
  description = "Kubernetes service type"
  type        = string
  default     = "ClusterIP"
  validation {
    condition     = contains(["ClusterIP", "NodePort", "LoadBalancer"], var.service_type)
    error_message = "Service type must be ClusterIP, NodePort, or LoadBalancer."
  }
}

variable "node_port" {
  description = "NodePort for ArgoCD server (only used if service_type is NodePort)"
  type        = number
  default     = 30080
}

variable "ingress_enabled" {
  description = "Enable ingress for ArgoCD"
  type        = bool
  default     = false
}

variable "ingress_host" {
  description = "Hostname for ArgoCD ingress"
  type        = string
  default     = "argocd.local"
}

variable "resources" {
  description = "Resource limits and requests"
  type = object({
    server = object({
      requests = object({
        memory = string
        cpu    = string
      })
      limits = object({
        memory = string
        cpu    = string
      })
    })
    repoServer = object({
      requests = object({
        memory = string
        cpu    = string
      })
      limits = object({
        memory = string
        cpu    = string
      })
    })
  })
  default = {
    server = {
      requests = {
        memory = "128Mi"
        cpu    = "100m"
      }
      limits = {
        memory = "256Mi"
        cpu    = "200m"
      }
    }
    repoServer = {
      requests = {
        memory = "128Mi"
        cpu    = "100m"
      }
      limits = {
        memory = "256Mi"
        cpu    = "200m"
      }
    }
  }
}

variable "additional_values" {
  description = "Additional Helm values to set"
  type        = map(string)
  default     = {}
}

variable "create_platform_project" {
  description = "Whether to create the platform ArgoCD project"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
