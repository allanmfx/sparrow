# =============================================================================
# Monitoring Module - Professional Implementation
# Grafana + Prometheus + Loki Integration
# =============================================================================

resource "kubernetes_namespace" "monitoring" {
  count = var.create_namespace ? 1 : 0
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "prometheus_stack" {
  name       = "prometheus"
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
    name  = "prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues"
    value = "false"
  }

  set {
    name  = "prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues"
    value = "false"
  }

  # Add Loki as datasource
  set {
    name  = "grafana.additionalDataSources[0].name"
    value = "Loki"
  }

  set {
    name  = "grafana.additionalDataSources[0].type"
    value = "loki"
  }

  set {
    name  = "grafana.additionalDataSources[0].access"
    value = "proxy"
  }

  set {
    name  = "grafana.additionalDataSources[0].url"
    value = "http://loki.monitoring.svc.cluster.local:3100"
  }

  set {
    name  = "grafana.additionalDataSources[0].isDefault"
    value = "false"
  }

  depends_on = [kubernetes_namespace.monitoring]
}

# Grafana configuration for Loki integration
resource "kubernetes_config_map" "grafana_config" {
  count = var.create_namespace ? 1 : 0
  metadata {
    name      = "grafana-config"
    namespace = var.namespace
  }

  data = {
    "grafana.ini" = <<-EOT
      [server]
      root_url = http://localhost:3000/
      
      [auth.anonymous]
      enabled = false
      
      [datasources]
      default = prometheus
      
      [log]
      level = info
    EOT
  }

  depends_on = [helm_release.prometheus_stack]
}
