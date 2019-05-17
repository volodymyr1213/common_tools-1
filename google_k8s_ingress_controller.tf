provider "helm" {
  tiller_image = "gcr.io/kubernetes-helm/tiller:${var.tiller_version}"
  service_account = "tiller"
  kubernetes {
  }
}

## Deploy ingress controller 
resource "helm_release" "ingress-controller" {
  depends_on = [
    "kubernetes_namespace.service_tools",
    "kubernetes_service_account.tiller",
    "kubernetes_secret.tiller",
    "kubernetes_cluster_role_binding.tiller-cluster-rule"
  ]

  name      = "fuchicorp-ingress-controller"
  chart     = "stable/nginx-ingress"
  namespace = "${var.namespace}"
}
