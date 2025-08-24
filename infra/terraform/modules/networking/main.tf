# =============================================================================
# Networking Module - Ingress & Load Balancer
# =============================================================================

resource "kubernetes_namespace" "ingress" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = var.namespace
    labels = {
      name                          = var.namespace
      "app.kubernetes.io/name"      = "ingress"
      "app.kubernetes.io/component" = "networking"
    }
  }
}

resource "helm_release" "traefik" {
  name       = var.release_name
  repository = "https://traefik.github.io/charts"
  chart      = "traefik"
  namespace  = var.namespace
  version    = var.chart_version

  values = [
    file("${path.module}/values.yaml")
  ]

  depends_on = [
    kubernetes_namespace.ingress
  ]

  set {
    name  = "service.type"
    value = var.service_type
  }

  set {
    name  = "ports.web.nodePort"
    value = var.web_node_port
  }

  set {
    name  = "ports.websecure.nodePort"
    value = var.websecure_node_port
  }
}
