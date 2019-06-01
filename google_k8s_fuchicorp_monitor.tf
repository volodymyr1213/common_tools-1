resource "kubernetes_deployment" "monitor_deployment" {
  depends_on = [
    "kubernetes_namespace.service_tools",
    "kubernetes_service_account.tiller",
    "kubernetes_secret.tiller",
    "kubernetes_cluster_role_binding.tiller_cluster_rule",
    "helm_release.ingress_controller",
    "kubernetes_deployment.jenkins_fuchicorp_deployment",
    "kubernetes_deployment.grafana_fuchicorp_deployment",
    "kubernetes_deployment.vault_fuchicorp_deployment",
    "kubernetes_deployment.nexus_fuchicorp_deployment",
    "kubernetes_service.jenkins_fuchicorp_service",
    "kubernetes_service.grafana_fuchicorp_service",
    "kubernetes_service.vault_fuchicorp_service",
    "kubernetes_service.nexus_fuchicorp_service",
    "helm_release.cert_manager"
  ]

  metadata {
    namespace = "${var.namespace}"
    name = "monitor-deployment"
    labels { run = "monitor" }
  }

  spec {
    replicas = 1
    selector {
      match_labels { run = "monitor" } }

    template {
      metadata {
        labels { run = "monitor" }
      }

      spec {
        container {
          image = "${var.monitor_image}"
          name  = "monitor-container"
          command = [ "python", "/app/app.py" ]


          env {
            name = "SLACK_API_TOKEN"
            value = "${var.slack_python_token}"
          }
        }
      }
    }
  }
}
