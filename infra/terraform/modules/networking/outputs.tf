# =============================================================================
# Networking Module Outputs
# =============================================================================

output "traefik_url" {
  description = "Traefik dashboard URL"
  value       = "http://localhost:${var.web_node_port}"
}

output "traefik_secure_url" {
  description = "Traefik secure URL"
  value       = "https://localhost:${var.websecure_node_port}"
}

output "namespace" {
  description = "Namespace name"
  value       = var.namespace
}
