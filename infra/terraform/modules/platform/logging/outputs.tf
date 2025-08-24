# =============================================================================
# Logging Module Outputs - Professional Configuration
# =============================================================================

output "namespace" {
  description = "Logging namespace"
  value       = var.namespace
}

output "loki_release_name" {
  description = "Loki Helm release name"
  value       = helm_release.loki.name
}

output "alloy_release_name" {
  description = "Grafana Alloy Helm release name"
  value       = helm_release.alloy.name
}

output "loki_chart_version" {
  description = "Deployed Loki chart version"
  value       = helm_release.loki.version
}

output "alloy_chart_version" {
  description = "Deployed Alloy chart version"
  value       = helm_release.alloy.version
}

output "loki_url" {
  description = "Loki access URL"
  value = var.service_type == "NodePort" ? "http://localhost:${var.loki_node_port}" : (
    "http://loki.${var.namespace}.svc.cluster.local:3100"
  )
}

output "kubectl_commands" {
  description = "Useful kubectl commands"
  value = {
    get_pods          = "kubectl get pods -n ${var.namespace}"
    get_services      = "kubectl get svc -n ${var.namespace}"
    loki_port_forward = var.service_type == "ClusterIP" ? "kubectl port-forward svc/loki ${var.loki_node_port}:3100 -n ${var.namespace}" : null
    loki_logs         = "kubectl logs -l app.kubernetes.io/name=loki -n ${var.namespace}"
    alloy_logs        = "kubectl logs -l app.kubernetes.io/name=alloy -n ${var.namespace}"
  }
}
