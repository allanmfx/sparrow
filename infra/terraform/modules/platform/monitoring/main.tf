# =============================================================================
# Monitoring Module
# Prometheus + Grafana Stack
# =============================================================================

resource "kubernetes_namespace" "monitoring" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = var.namespace
    labels = {
      name                          = var.namespace
      "app.kubernetes.io/name"      = "monitoring"
      "app.kubernetes.io/component" = "observability"
    }
  }
}

resource "helm_release" "prometheus_stack" {
  name       = var.release_name
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = var.namespace
  version    = var.chart_version

  values = [
    file("${path.module}/values.yaml")
  ]

  set {
    name  = "grafana.adminPassword"
    value = var.grafana_password
  }

  set {
    name  = "grafana.service.type"
    value = var.service_type
  }

  set {
    name  = "grafana.service.nodePort"
    value = var.grafana_node_port
  }

  set {
    name  = "prometheus.service.type"
    value = var.service_type
  }

  set {
    name  = "prometheus.service.nodePort"
    value = var.prometheus_node_port
  }

  depends_on = [
    kubernetes_namespace.monitoring
  ]

  dynamic "set" {
    for_each = var.additional_values
    content {
      name  = set.key
      value = set.value
    }
  }
}

# Grafana ConfigMap for datasources and dashboards
resource "kubernetes_config_map" "grafana_config" {
  count = var.create_grafana_config ? 1 : 0

  depends_on = [helm_release.prometheus_stack]

  metadata {
    name      = "grafana-config"
    namespace = var.namespace
  }

  data = {
    "loki-datasource.yaml" = templatefile("${path.module}/grafana/loki-datasource.yaml", {
      loki_url = var.loki_url
    })

    "logs-dashboard.json" = file("${path.module}/grafana/logs-dashboard.json")
  }
}
