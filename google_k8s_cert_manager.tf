# Deploy cert manger
resource "helm_release" "cert_manager" {
  depends_on = [
    "kubernetes_namespace.service_tools",
    "kubernetes_service_account.tiller",
    "kubernetes_secret.tiller",
    "kubernetes_cluster_role_binding.tiller_cluster_rule",
    "kubernetes_deployment.vault_fuchicorp_deployment",
    "kubernetes_service.vault_fuchicorp_service",
    "kubernetes_service.nexus_fuchicorp_service",
  ] # "helm_release.grafana",

  name      = "fuchicorp-cert-manager"
  chart     = "jetstack/cert-manager"
  namespace = "${var.deployment_environment}"

  wait = true
}

## Code should run first bellow comamnd and then deploy the code
# kubectl apply --validate=false  -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.12/deploy/manifests/00-crds.yaml

