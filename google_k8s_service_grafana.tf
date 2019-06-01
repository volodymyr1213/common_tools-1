resource "kubernetes_deployment" "grafana_fuchicorp_deployment" {
  depends_on = [
    "kubernetes_secret.grafana_secrets",
    "kubernetes_namespace.service_tools" ]

  metadata {
    name      = "grafana-fuchicorp-deployment"
    namespace = "${var.namespace}"

    labels {
      app = "grafana_fuchicorp_deployment"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels {
        app = "grafana-fuchicorp-deployment"
      }
    }

    template {
      metadata {
        labels {
          app = "grafana-fuchicorp-deployment"
        }
      }

      spec {

        container {
          name  = "grafana-fuchicorp-deployment"
          image = "grafana/grafana:4.2.0"

          port {
            container_port = 3000
            protocol       = "TCP"
          }

          env {
            name  = "GF_AUTH_BASIC_ENABLED"
            value = "true"
          }

          env {
            name = "GF_SECURITY_ADMIN_USER"

            value_from {
              secret_key_ref {
                name = "grafana-secrets"
                key  = "username"
              }
            }
          }

          env {
            name = "GF_SECURITY_ADMIN_PASSWORD"

            value_from {
              secret_key_ref {
                name = "grafana-secrets"
                key  = "password"
              }
            }
          }

          env {
            name  = "GF_AUTH_ANONYMOUS_ENABLED"
            value = "false"
          }

          resources {
            limits {
              cpu    = "100m"
              memory = "100Mi"
            }

            requests {
              cpu    = "100m"
              memory = "100Mi"
            }
          }
          image_pull_policy = "IfNotPresent"
        }
      }
    }
  }
}

resource "kubernetes_secret" "grafana_secrets" {
  metadata {
    name = "grafana-secrets"

    namespace = "${var.namespace}"
  }

  data {
    password = "${var.grafana_password}"
    username = "${var.grafana_username}"
  }

  type = "Opaque"
}

resource "kubernetes_service" "grafana_fuchicorp_service" {
  depends_on = ["kubernetes_secret.grafana_secrets"]
  depends_on = ["kubernetes_namespace.service_tools"]

  metadata {
    name      = "grafana-fuchicorp-service"
    namespace = "${var.namespace}"
  }

  spec {
    selector {
      app = "grafana_fuchicorp_deployment"
    }

    port {
      protocol    = "TCP"
      port        = "${var.grafana_service_port}"
      target_port = 3000
    }

    type = "NodePort"
  }
}
