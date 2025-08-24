# =============================================================================
# Terraform Backend Configuration
# Local Environment - Uses existing Kubernetes cluster
# =============================================================================

terraform {
  required_version = ">= 1.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
  }

  # Local state for development
  backend "local" {
    path = "terraform.tfstate"
  }
}

# Kubernetes provider - uses current context
provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = var.cluster_name
}

# Helm provider - uses current context
provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = var.cluster_name
  }
}
