## Before deploy ingress for each services it will make sure all services available
resource "helm_release" "fuchicorp-services-ingress" {
  depends_on = [
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
  name = "fuchicorp-services-ingress-${var.namespace}"
  namespace = "${var.namespace}"
  chart = "./helm-fuchicorp"
  set {
    name = "grafanaport"
    value = "${var.grafana_service_port}"
  }

  set {
    name = "jenkinsport"
    value = "${var.jenkins_service_port}"
  }

  set {
    name = "jiraport"
    value = "${var.jira_service_port}"
  }

  set {
    name = "nexusport"
    value = "${var.nexus_service_port}"
  }

  set {
    name = "vaultport"
    value = "${var.vault_service_port}"
  }

  set {
    name = "repo_port"
    value = "${var.repo_port}"
  }

  set {
    name = "email"
    value = "${var.email}"
  }

  set {
    name = "wordpressport"
    value = "${var.wordpress_tools_service_port}"
  }
}
