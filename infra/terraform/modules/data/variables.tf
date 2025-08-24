variable "namespace" {
  description = "Namespace for data components"
  type        = string
  default     = "data"
}

variable "postgresql_release_name" {
  description = "Helm release name for PostgreSQL"
  type        = string
  default     = "postgresql"
}

variable "postgresql_chart_version" {
  description = "PostgreSQL chart version"
  type        = string
  default     = "13.2.26"
}

variable "postgresql_password" {
  description = "PostgreSQL password"
  type        = string
  default     = "postgres123"
  sensitive   = true
}

variable "service_type" {
  description = "Service type"
  type        = string
  default     = "NodePort"
}

variable "postgresql_node_port" {
  description = "PostgreSQL NodePort"
  type        = number
  default     = 5432
}

variable "create_namespace" {
  description = "Whether to create the namespace"
  type        = bool
  default     = true
}
