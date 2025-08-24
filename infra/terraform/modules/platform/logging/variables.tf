# =============================================================================
# Logging Module Variables
# =============================================================================

variable "namespace" {
  description = "Kubernetes namespace for logging"
  type        = string
  default     = "monitoring"
}

variable "loki_chart_version" {
  description = "Loki Helm chart version"
  type        = string
  default     = "5.41.4"
}

variable "promtail_chart_version" {
  description = "Promtail Helm chart version"
  type        = string
  default     = "6.17.0"
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

variable "loki_node_port" {
  description = "NodePort for Loki (only used if service_type is NodePort)"
  type        = number
  default     = 3100
}

variable "resources" {
  description = "Resource limits and requests"
  type = object({
    loki = object({
      requests = object({
        memory = string
        cpu    = string
      })
      limits = object({
        memory = string
        cpu    = string
      })
    })
    promtail = object({
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
    loki = {
      requests = {
        memory = "128Mi"
        cpu    = "100m"
      }
      limits = {
        memory = "256Mi"
        cpu    = "200m"
      }
    }
    promtail = {
      requests = {
        memory = "64Mi"
        cpu    = "50m"
      }
      limits = {
        memory = "128Mi"
        cpu    = "100m"
      }
    }
  }
}

variable "enable_s3_storage" {
  description = "Enable S3 storage for Loki"
  type        = bool
  default     = false
}

variable "s3_bucket" {
  description = "S3 bucket for Loki storage"
  type        = string
  default     = ""
}

variable "loki_url" {
  description = "Loki service URL for Promtail"
  type        = string
  default     = "http://loki-gateway.monitoring.svc.cluster.local/loki/api/v1/push"
}

variable "module_dependencies" {
  description = "Dependencies for the logging module"
  type        = any
  default     = []
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
