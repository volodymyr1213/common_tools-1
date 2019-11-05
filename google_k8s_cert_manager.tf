## Deploy cert manger
resource "helm_release" "cert_manager" {
  depends_on = [
    "kubernetes_namespace.service_tools",
    "kubernetes_service_account.tiller",
    "kubernetes_secret.tiller",
    "kubernetes_cluster_role_binding.tiller_cluster_rule",
    "helm_release.ingress_controller",
    "helm_release.grafana",
    "kubernetes_deployment.vault_fuchicorp_deployment",
    "kubernetes_deployment.nexus_fuchicorp_deployment",
    "kubernetes_service.vault_fuchicorp_service",
    "kubernetes_service.nexus_fuchicorp_service",
  ]

  name      = "fuchicorp-cert-manager"
  chart     = "stable/cert-manager"
  namespace = "${var.namespace}"
  version   = "v0.3.0"
  wait      = true

  set {
    name  = "ingressShim.defaultIssuerName"
    value = "letsencrypt-fuchicorp-prod"
  }

  set {
    name  = "ingressShim.defaultIssuerKind"
    value = "ClusterIssuer"
  }
}
