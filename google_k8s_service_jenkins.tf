## jenkins deployment depens os services namespaces
resource "kubernetes_deployment" "jenkins_fuchicorp_deployment" {
  depends_on = [
    "kubernetes_namespace.service_tools",
    "kubernetes_service_account.common_service_account"
  ]
  metadata {
    name = "jenkins-fuchicorp-deployment"

    namespace = "${var.namespace}"

    labels {
      app = "jenkins-terraform-deployment"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels {
        app = "jenkins-pod"
      }
    }

    template {
      metadata {
        labels {
          app = "jenkins-pod"
        }
      }
      spec {
        service_account_name = "${kubernetes_service_account.common_service_account.metadata.0.name}"

        container {

          image = "fsadykov/centos_jenkins:kube"
          name  = "jenkins"

          env {
            name = "SERVICE_CERT_FILENAME"
            value = "/var/run/secrets/kubernetes.io/serviceaccount"
          }

          env_from {
            secret_ref {
              name = "${kubernetes_secret.common_service_account_secret.metadata.0.name}"
            }
          }

          volume_mount {
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
            name = "${kubernetes_service_account.common_service_account.default_secret_name}"
            read_only = true
          }

          volume_mount {
            name       = "docker-sock"
            mount_path = "/var/run/docker.sock"
          }

          volume_mount {
            name       = "jenkins-home"
            mount_path = "/root/.jenkins"
          }


        }

        volume {
          name = "${kubernetes_service_account.common_service_account.default_secret_name}"
          secret {
            secret_name = "${kubernetes_service_account.common_service_account.default_secret_name}"
          }
        }

        volume {
          name = "docker-sock"

          host_path = {
            path = "/var/run/docker.sock"
          }
        }

        volume {
          name = "jenkins-home"

          persistent_volume_claim {
            claim_name = "jenkins-pvc"
          }
        }
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "jenkins-pvc" {
  depends_on = ["kubernetes_namespace.service_tools"]
  metadata {
    name      = "jenkins-pvc"
    namespace = "${var.namespace}"
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests {
        storage = "10Gi"
      }
    }
  }
}

resource "kubernetes_service" "jenkins_fuchicorp_service" {
  depends_on = ["kubernetes_namespace.service_tools"]
  metadata {
    name      = "jenkins-fuchicorp-service"
    namespace = "${var.namespace}"
  }

  spec {
    port {
      protocol    = "TCP"
      port        = "${var.jenkins_service_port}"
      target_port = 8080
    }

    selector {
      app = "jenkins-pod"
    }

    type = "NodePort"
  }
}
