## Deploy cert manger
resource "helm_release" "cert-manager" {
 depends_on = [
   "kubernetes_namespace.service_tools",
   "kubernetes_service_account.tiller",
   "kubernetes_secret.tiller",
   "kubernetes_cluster_role_binding.tiller-cluster-rule",
   "helm_release.ingress-controller",
   "kubernetes_deployment.jenkins-fuchicorp-deployment",
   "kubernetes_deployment.jira-fuchicorp-deployment",
   "kubernetes_deployment.grafana-fuchicorp-deployment",
   "kubernetes_deployment.vault-fuchicorp-deployment",
   "kubernetes_deployment.nexus-fuchicorp-deployment",
   "kubernetes_service.jenkins-fuchicorp-service",
   "kubernetes_service.jira-fuchicorp-service",
   "kubernetes_service.grafana-fuchicorp-service",
   "kubernetes_service.vault-fuchicorp-service",
   "kubernetes_service.nexus-fuchicorp-service"
 ]

 name      = "fuchicorp-cert-manager"
 chart     = "stable/cert-manager"
 namespace = "${var.namespace}"
 version   = "v0.3.0"

 set {
   name  = "ingressShim.defaultIssuerName"
   value = "letsencrypt-fuchicorp-prod"
 }
 set {
   name  = "ingressShim.defaultIssuerKind"
   value = "ClusterIssuer"
 }
}
