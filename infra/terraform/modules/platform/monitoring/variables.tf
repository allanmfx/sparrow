# =============================================================================
# Monitoring Module Variables
# =============================================================================

variable "namespace" {
  description = "Kubernetes namespace for monitoring"
  type        = string
  default     = "monitoring"
}

variable "create_namespace" {
  description = "Whether to create the namespace"
  type        = bool
  default     = true
}

variable "release_name" {
  description = "Helm release name"
  type        = string
  default     = "prometheus"
}

variable "chart_version" {
  description = "Prometheus Stack Helm chart version"
  type        = string
  default     = "55.5.0"
}

variable "grafana_password" {
  description = "Grafana admin password"
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

variable "grafana_node_port" {
  description = "NodePort for Grafana (only used if service_type is NodePort)"
  type        = number
  default     = 30000
}

variable "prometheus_node_port" {
  description = "NodePort for Prometheus (only used if service_type is NodePort)"
  type        = number
  default     = 30001
}

variable "ingress_enabled" {
  description = "Enable ingress for Grafana"
  type        = bool
  default     = false
}

variable "grafana_hostname" {
  description = "Hostname for Grafana ingress"
  type        = string
  default     = "grafana.local"
}

variable "resources" {
  description = "Resource limits and requests"
  type = object({
    grafana = object({
      requests = object({
        memory = string
        cpu    = string
      })
      limits = object({
        memory = string
        cpu    = string
      })
    })
    prometheus = object({
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
    grafana = {
      requests = {
        memory = "128Mi"
        cpu    = "100m"
      }
      limits = {
        memory = "256Mi"
        cpu    = "200m"
      }
    }
    prometheus = {
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

variable "enable_ha" {
  description = "Enable high availability"
  type        = bool
  default     = false
}

variable "additional_values" {
  description = "Additional Helm values to set"
  type        = map(string)
  default     = {}
}

variable "create_grafana_config" {
  description = "Whether to create Grafana ConfigMap"
  type        = bool
  default     = true
}

variable "loki_url" {
  description = "Loki service URL"
  type        = string
  default     = "http://loki-gateway.monitoring.svc.cluster.local"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
