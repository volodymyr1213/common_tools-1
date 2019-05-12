resource "kubernetes_deployment" "jenkins-fuchicorp-deployment" {
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
        container {
          image = "fsadykov/centos_jenkins:0.3"
          name  = "jenkins"

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
  metadata {
    name      = "jenkins-pvc"
    namespace = "${var.namespace}"
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests {
        storage = "20Gi"
      }
    }
  }
}

resource "kubernetes_service" "jenkins-fuchicorp-service" {
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
