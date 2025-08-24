# =============================================================================
# Logging Module Variables - Professional Configuration
# =============================================================================

variable "namespace" {
  description = "Kubernetes namespace for logging"
  type        = string
  default     = "monitoring"
}

variable "loki_chart_version" {
  description = "Loki Helm chart version"
  type        = string
  default     = "6.37.0"
}

variable "alloy_chart_version" {
  description = "Grafana Alloy Helm chart version"
  type        = string
  default     = "0.1.0"
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
    alloy = object({
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
        memory = "256Mi"
        cpu    = "200m"
      }
      limits = {
        memory = "512Mi"
        cpu    = "400m"
      }
    }
    alloy = {
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

variable "loki_url" {
  description = "Loki service URL for Alloy"
  type        = string
  default     = "http://loki.monitoring.svc.cluster.local:3100/loki/api/v1/push"
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
