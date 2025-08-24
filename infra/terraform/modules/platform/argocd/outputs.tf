# =============================================================================
# ArgoCD Module Outputs
# =============================================================================

output "namespace" {
  description = "ArgoCD namespace"
  value       = var.namespace
}

output "release_name" {
  description = "Helm release name"
  value       = helm_release.argocd.name
}

output "chart_version" {
  description = "Deployed chart version"
  value       = helm_release.argocd.version
}

output "service_name" {
  description = "ArgoCD server service name"
  value       = "${var.release_name}-server"
}

output "admin_password" {
  description = "ArgoCD admin password"
  value       = var.admin_password
  sensitive   = true
}

output "url" {
  description = "ArgoCD access URL"
  value = var.service_type == "NodePort" ? "http://localhost:${var.node_port}" : (
    var.ingress_enabled ? "https://${var.ingress_host}" : "http://${var.release_name}-server.${var.namespace}.svc.cluster.local"
  )
}

output "kubectl_commands" {
  description = "Useful kubectl commands"
  value = {
    get_pods     = "kubectl get pods -n ${var.namespace}"
    get_services = "kubectl get svc -n ${var.namespace}"
    port_forward = var.service_type == "ClusterIP" ? "kubectl port-forward svc/${var.release_name}-server 8080:80 -n ${var.namespace}" : null
    logs_server  = "kubectl logs -l app.kubernetes.io/name=argocd-server -n ${var.namespace}"
  }
}
