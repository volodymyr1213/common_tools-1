## Before deploy ingress for each services it will make sure all services available
resource "helm_release" "fuchicorp_services_ingress" {
  depends_on = [
    "kubernetes_deployment.vault_fuchicorp_deployment",
    "kubernetes_service.vault_fuchicorp_service",
    "kubernetes_service.nexus_fuchicorp_service",
  ] # "kubernetes_deployment.nexus_fuchicorp_deployment",

  wait      = true
  name      = "fuchicorp-services-ingress-${var.deployment_environment}"
  namespace = "${var.deployment_environment}"
  chart     = "./helm-fuchicorp"

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
}


