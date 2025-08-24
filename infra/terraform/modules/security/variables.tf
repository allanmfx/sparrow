variable "namespace" {
  description = "Namespace for security components"
  type        = string
  default     = "security"
}

variable "cert_manager_release_name" {
  description = "Helm release name for cert-manager"
  type        = string
  default     = "cert-manager"
}

variable "cert_manager_chart_version" {
  description = "cert-manager chart version"
  type        = string
  default     = "1.13.3"
}

variable "create_namespace" {
  description = "Whether to create the namespace"
  type        = bool
  default     = true
}
