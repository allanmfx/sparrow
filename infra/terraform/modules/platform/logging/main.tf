# =============================================================================
# Logging Module
# Loki + Promtail Stack
# =============================================================================

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

  depends_on = [var.module_dependencies]
}

resource "helm_release" "promtail" {
  name       = "promtail"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "promtail"
  namespace  = var.namespace
  version    = var.promtail_chart_version

  values = [
    file("${path.module}/promtail-values.yaml")
  ]

  set {
    name  = "config.clients[0].url"
    value = var.loki_url
  }

  depends_on = [helm_release.loki]
}
