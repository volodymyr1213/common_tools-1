## Deploy external_dns controller
resource "helm_release" "external_dns_controller" {
  depends_on = [
    "kubernetes_namespace.service_tools",
    "kubernetes_service_account.tiller",
    "kubernetes_secret.tiller",
    "kubernetes_cluster_role_binding.tiller_cluster_rule"
  ]

  name      = "fuchicorp-external-dns"
  chart     = "./helm-external-dns"
  namespace = "${var.namespace}"
}
