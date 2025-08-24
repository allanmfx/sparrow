# =============================================================================
# Logging Module - Professional Implementation
# Loki + Grafana Alloy Stack (Simplified)
# =============================================================================

# Loki - Simplified Configuration
resource "helm_release" "loki" {
  name       = "loki"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki"
  namespace  = var.namespace
  version    = var.loki_chart_version

  values = [
    file("${path.module}/loki-values.yaml")
  ]

  set {
    name  = "service.type"
    value = var.service_type
  }

  set {
    name  = "service.nodePort"
    value = var.loki_node_port
  }

  depends_on = [var.module_dependencies, helm_release.alloy]
}

# Grafana Alloy - Modern Agent
resource "helm_release" "alloy" {
  name       = "alloy"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "alloy"
  namespace  = var.namespace
  version    = var.alloy_chart_version

  values = [
    file("${path.module}/alloy-values.yaml")
  ]

  depends_on = [var.module_dependencies]
}
