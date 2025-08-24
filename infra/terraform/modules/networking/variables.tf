# =============================================================================
# Networking Module Variables
# =============================================================================

variable "namespace" {
  description = "Namespace for networking components"
  type        = string
  default     = "ingress"
}

variable "release_name" {
  description = "Helm release name for Traefik"
  type        = string
  default     = "traefik"
}

variable "chart_version" {
  description = "Traefik chart version"
  type        = string
  default     = "24.0.0"
}

variable "service_type" {
  description = "Service type for Traefik"
  type        = string
  default     = "NodePort"
}

variable "web_node_port" {
  description = "NodePort for HTTP traffic"
  type        = number
  default     = 80
}

variable "websecure_node_port" {
  description = "NodePort for HTTPS traffic"
  type        = number
  default     = 443
}

variable "create_namespace" {
  description = "Whether to create the namespace"
  type        = bool
  default     = true
}
