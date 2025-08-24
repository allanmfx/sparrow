# =============================================================================
# Logging Module Outputs
# =============================================================================

output "namespace" {
  description = "Logging namespace"
  value       = var.namespace
}

output "loki_release_name" {
  description = "Loki Helm release name"
  value       = helm_release.loki.name
}

output "promtail_release_name" {
  description = "Promtail Helm release name"
  value       = helm_release.promtail.name
}

output "loki_chart_version" {
  description = "Deployed Loki chart version"
  value       = helm_release.loki.version
}

output "promtail_chart_version" {
  description = "Deployed Promtail chart version"
  value       = helm_release.promtail.version
}

output "loki_url" {
  description = "Loki access URL"
  value = var.service_type == "NodePort" ? "http://localhost:${var.loki_node_port}" : (
    "http://loki-gateway.${var.namespace}.svc.cluster.local"
  )
}

output "kubectl_commands" {
  description = "Useful kubectl commands"
  value = {
    get_pods          = "kubectl get pods -n ${var.namespace}"
    get_services      = "kubectl get svc -n ${var.namespace}"
    loki_port_forward = var.service_type == "ClusterIP" ? "kubectl port-forward svc/loki-gateway ${var.loki_node_port}:80 -n ${var.namespace}" : null
    loki_logs         = "kubectl logs -l app.kubernetes.io/name=loki -n ${var.namespace}"
    promtail_logs     = "kubectl logs -l app.kubernetes.io/name=promtail -n ${var.namespace}"
  }
}
