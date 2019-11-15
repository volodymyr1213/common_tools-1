## Before deploy ingress for each services it will make sure all services available
resource "helm_release" "fuchicorp_services_ingress" {
  depends_on = [
    "helm_release.ingress_controller",
    "kubernetes_deployment.vault_fuchicorp_deployment",
    "kubernetes_deployment.nexus_fuchicorp_deployment",
    "kubernetes_service.vault_fuchicorp_service",
    "kubernetes_service.nexus_fuchicorp_service",
  ]

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

resource "kubernetes_secret" "example" {
  metadata {
    name      = "google-service-account"
    namespace = "${var.deployment_environment}"
  }

  data = {
    "credentials.json" = "${file("${path.module}/fuchicorp-service-account.json")}"
  }

  type = "generic"
}
