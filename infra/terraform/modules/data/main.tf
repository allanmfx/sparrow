# =============================================================================
# Data Module - PostgreSQL & Redis
# =============================================================================

resource "kubernetes_namespace" "data" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = var.namespace
    labels = {
      name                          = var.namespace
      "app.kubernetes.io/name"      = "data"
      "app.kubernetes.io/component" = "database"
    }
  }
}

resource "helm_release" "postgresql" {
  name       = var.postgresql_release_name
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"
  namespace  = var.namespace
  version    = var.postgresql_chart_version

  values = [
    file("${path.module}/postgresql-values.yaml")
  ]

  depends_on = [
    kubernetes_namespace.data
  ]

  set {
    name  = "auth.postgresPassword"
    value = var.postgresql_password
  }

  set {
    name  = "service.type"
    value = var.service_type
  }

  set {
    name  = "service.nodePort"
    value = var.postgresql_node_port
  }
}
