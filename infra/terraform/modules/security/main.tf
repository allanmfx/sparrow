# =============================================================================
# Security Module - Certificates & Policies
# =============================================================================

resource "kubernetes_namespace" "security" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = var.namespace
    labels = {
      name                          = var.namespace
      "app.kubernetes.io/name"      = "security"
      "app.kubernetes.io/component" = "security"
    }
  }
}

resource "helm_release" "cert_manager" {
  name       = var.cert_manager_release_name
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = var.namespace
  version    = var.cert_manager_chart_version

  values = [
    file("${path.module}/cert-manager-values.yaml")
  ]

  depends_on = [
    kubernetes_namespace.security
  ]

  set {
    name  = "installCRDs"
    value = "true"
  }
}
