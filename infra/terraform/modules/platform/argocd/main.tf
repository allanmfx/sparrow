# =============================================================================
# ArgoCD Module
# GitOps Platform for Kubernetes
# =============================================================================

resource "kubernetes_namespace" "argocd" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = var.namespace
    labels = {
      name                          = var.namespace
      "app.kubernetes.io/name"      = "argocd"
      "app.kubernetes.io/component" = "gitops"
    }
  }
}

resource "helm_release" "argocd" {
  name       = var.release_name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = var.namespace
  version    = var.chart_version

  values = [
    file("${path.module}/values.yaml")
  ]

  set {
    name  = "server.service.type"
    value = var.service_type
  }

  set {
    name  = "server.service.nodePort"
    value = var.node_port
  }

  set {
    name  = "server.ingress.enabled"
    value = var.ingress_enabled
  }

  set {
    name  = "configs.secret.argocdServerAdminPassword"
    value = var.admin_password
  }

  depends_on = [
    kubernetes_namespace.argocd
  ]

  dynamic "set" {
    for_each = var.additional_values
    content {
      name  = set.key
      value = set.value
    }
  }
}

# ArgoCD Project for the platform
# Note: This will be created manually or via ArgoCD UI
# The kubernetes_manifest resource has issues with REST client creation
