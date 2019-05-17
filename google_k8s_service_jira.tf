resource "kubernetes_persistent_volume_claim" "jira-pvc" {
  depends_on = ["kubernetes_namespace.service_tools"]
  metadata {
    name = "jira-pvc"

    namespace = "${var.namespace}"

    labels {
      app = "jira-fuchicorp-deployment"
    }
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests {
        storage = "10Gi"
      }
    }

    storage_class_name = "standard"
  }
}

## Jira deployment depends on service_tools
resource "kubernetes_deployment" "jira-fuchicorp-deployment" {
  depends_on = ["kubernetes_namespace.service_tools"]
  metadata {
    name = "jira-fuchicorp-deployment"

    namespace = "${var.namespace}"

    labels {
      app = "jira-fuchicorp-deployment"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels {
        app = "jira-fuchicorp-deployment"
      }
    }

    template {
      metadata {
        labels {
          app = "jira-fuchicorp-deployment"
        }
      }

      spec {
        volume {
          name = "jira-pvc"

          persistent_volume_claim {
            claim_name = "jira-pvc"
          }
        }

        container {
          image = "gcr.io/hightowerlabs/jira:7.3.6-standalone"
          name  = "jira-fuchicorp-deployment"

          port {
            container_port = 8080
            protocol       = "TCP"
          }

          volume_mount {
            name       = "jira-pvc"
            mount_path = "/var/lib/jira"
          }

          image_pull_policy = "IfNotPresent"
        }
      }
    }
  }
}

resource "kubernetes_service" "jira-fuchicorp-service" {
  depends_on = ["kubernetes_namespace.service_tools"]
  metadata {
    name = "jira-fuchicorp-service"

    namespace = "${var.namespace}"
  }

  spec {
    port {
      protocol    = "TCP"
      port        = "${var.jira_service_port}"
      target_port = 8080
    }

    selector {
      app = "jira-fuchicorp-deployment"
    }

    type = "NodePort"
  }
}
