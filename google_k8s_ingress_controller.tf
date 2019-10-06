provider "helm" {
  tiller_image = "gcr.io/kubernetes-helm/tiller:${var.tiller_version}"
  service_account = "tiller"
  kubernetes {
  }
}

## Deploy ingress controller
resource "helm_release" "ingress_controller" {
  depends_on = [
    "kubernetes_namespace.service_tools",
    "kubernetes_service_account.tiller",
    "kubernetes_secret.tiller",
    "kubernetes_cluster_role_binding.tiller_cluster_rule"
  ]

  name      = "fuchicorp-ingress-controller"
  chart     = "./helm-ingress-controller"
  namespace = "${var.namespace}"
}
