## Before deploy ingress for each services it will make sure all services available
resource "helm_release" "services_ingress" {
  depends_on = [
    "kubernetes_deployment.vault_deployment",
    "kubernetes_service.vault_service",
    "kubernetes_service.nexus_service",
    "kubernetes_namespace.service_tools",
    "kubernetes_service_account.tiller",
    "kubernetes_secret.tiller",
    "kubernetes_service.vault_service",
    "kubernetes_cluster_role_binding.tiller_cluster_rule"
  ]

  wait      = true
  name      = "services-ingress-${var.deployment_environment}"
  namespace = "${var.deployment_environment}"
  chart     = "./main-helm"

  set {
    name  = "nexusport"
    value = "${var.nexus_service_port}"
  }

  set {
    name  = "vaultport"
    value = "${var.vault_service_port}"
  }

  set {
    name  = "repo_port"
    value = "${var.repo_port}"
  }

  set {
    name  = "email"
    value = "${var.email}"
  }

  set {
    name = "domain_name"
    value = "${var.google_domain_name}"
  }
}


