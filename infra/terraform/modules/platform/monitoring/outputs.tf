# =============================================================================
# Monitoring Module Outputs
# =============================================================================

output "namespace" {
  description = "Monitoring namespace"
  value       = var.namespace
}

output "release_name" {
  description = "Helm release name"
  value       = helm_release.prometheus_stack.name
}

output "chart_version" {
  description = "Deployed chart version"
  value       = helm_release.prometheus_stack.version
}

output "grafana_password" {
  description = "Grafana admin password"
  value       = var.grafana_password
  sensitive   = true
}

output "grafana_url" {
  description = "Grafana access URL"
  value = var.service_type == "NodePort" ? "http://localhost:${var.grafana_node_port}" : (
    var.ingress_enabled ? "https://${var.grafana_hostname}" : "http://${var.release_name}-grafana.${var.namespace}.svc.cluster.local"
  )
}

output "prometheus_url" {
  description = "Prometheus access URL"
  value = var.service_type == "NodePort" ? "http://localhost:${var.prometheus_node_port}" : (
    var.ingress_enabled ? "https://prometheus.${var.grafana_hostname}" : "http://${var.release_name}-prometheus.${var.namespace}.svc.cluster.local"
  )
}

output "kubectl_commands" {
  description = "Useful kubectl commands"
  value = {
    get_pods                = "kubectl get pods -n ${var.namespace}"
    get_services            = "kubectl get svc -n ${var.namespace}"
    grafana_port_forward    = var.service_type == "ClusterIP" ? "kubectl port-forward svc/${var.release_name}-grafana ${var.grafana_node_port}:80 -n ${var.namespace}" : null
    prometheus_port_forward = var.service_type == "ClusterIP" ? "kubectl port-forward svc/${var.release_name}-prometheus ${var.prometheus_node_port}:9090 -n ${var.namespace}" : null
    grafana_logs            = "kubectl logs -l app.kubernetes.io/name=grafana -n ${var.namespace}"
    prometheus_logs         = "kubectl logs -l app=prometheus -n ${var.namespace}"
  }
}
